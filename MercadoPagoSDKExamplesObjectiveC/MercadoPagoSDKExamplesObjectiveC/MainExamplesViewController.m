//
//  MainExamplesViewController.m
//  MercadoPagoSDKExamplesObjectiveC
//
//  Created by Maria cristina rodriguez on 1/7/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

#import "MainExamplesViewController.h"
#import "ExampleUtils.h"
//#import "FirstHookViewController.h"
//#import "SecondHookViewController.h"
//#import "ThirdHookViewController.h"

#import "MercadoPagoSDKExamplesObjectiveC-Swift.h"
#import "PaymentMethodPluginConfigViewController.h"
#import "PaymentPluginViewController.h"
#import "MLMyMPPXTrackListener.h"

@import MercadoPagoSDK;

@implementation MainExamplesViewController

- (IBAction)checkoutFlow:(id)sender {

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.opaque = YES;

    self.pref = nil;

    ///  PASO 1: SETEAR PREFERENCIAS

    // Setear ServicePreference
    // [self setServicePreference];

    ///  PASO 2: SETEAR CHECKOUTPREF, PAYMENTDATA Y PAYMENTRESULT

    // Setear una preferencia hecha a mano
    //[self setCheckoutPref_CardsNotExcluded];

    [self setCheckoutPref_WithId];

/*
    DiscountCoupon* dc = [[DiscountCoupon alloc] initWithDiscountId:123];
    
    NSNumber *externalDiscount = [NSNumber numberWithDouble:2.00];
    
    dc.name = @"Patito Off";
    dc.coupon_amount = [externalDiscount stringValue];
    dc.percent_off = @"10";
    dc.currency_id = @"ARS";
    dc.concept = @"Descuento de patito";
    dc.amountWithoutDiscount = 50;
    dc = nil;
*/
    


    // self.pref.preferenceId = @"243962506-ca09fbc6-7fa6-461d-951c-775b37d19abc";
    //Differential pricing
    // self.pref.preferenceId = @"99628543-518e6477-ac0d-4f4a-8097-51c2fcc00b71";
    /* self.mpCheckout = [[MercadoPagoCheckout alloc] initWithPublicKey:@"TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd"
                                                         accessToken:nil checkoutPreference:self.pref paymentData:self.paymentData paymentResult:self.paymentResult navigationController:self.navigationController]; */

//    self.pref.preferenceId = @"99628543-518e6477-ac0d-4f4a-8097-51c2fcc00b71";
//
//    self.checkoutBuilder = [[MercadoPagoCheckoutBuilder alloc] initWithPublicKey:@"TEST-c6d9b1f9-71ff-4e05-9327-3c62468a23ee" checkoutPreference:self.pref paymentConfiguration:[self getPaymentConfiguration]];

    self.checkoutBuilder = [[MercadoPagoCheckoutBuilder alloc] initWithPublicKey:@"TEST-4763b824-93d7-4ca2-a7f7-93539c3ee5bd" preferenceId:@"243966003-0812580b-6082-4104-9bce-1a4c48a5bc44"];

//    [self.checkoutBuilder setPrivateKeyWithKey:@"APP_USR-1094487241196549-081708-4bc39f94fd147e7ce839c230c93261cb__LA_LC__-145698489"];

    // AdvancedConfig
    PXAdvancedConfiguration* advancedConfig = [[PXAdvancedConfiguration alloc] init];

    // Add theme to advanced config.
    // MeliTheme *meliTheme = [[MeliTheme alloc] init];
    MPTheme *mpTheme = [[MPTheme alloc] init];
    [advancedConfig setTheme:mpTheme];

    // Add ReviewConfirm configuration to advanced config.
    [advancedConfig setReviewConfirmConfiguration: [self getReviewScreenConfiguration]];

    // Add PaymentResult configuration to advanced config.
    [advancedConfig setPaymentResultConfiguration: [self getPaymentResultConfiguration]];

    // Set advanced comnfig
    [self.checkoutBuilder setAdvancedConfigurationWithConfig:advancedConfig];

    // CDP color.
    // [self.checkoutComponents setDefaultColor:[UIColor colorWithRed:0.49 green:0.17 blue:0.55 alpha:1.0]];

    // [self.mpCheckout discountNotAvailable];

    // PXDiscount* discount = [[PXDiscount alloc] init];

    PXDiscount* discount = [[PXDiscount alloc] initWithId:@"34295216" name:@"nada" percentOff:20 amountOff:0 couponAmount:7 currencyId:@"ARG"];
    PXCampaign* campaign = [[PXCampaign alloc] initWithId:30959 code:@"sad" name:@"Campaña" maxCouponAmount:7];
    
    // [self.mpCheckout setDiscount:discount withCampaign:campaign];
    
    NSMutableArray* chargesArray = [[NSMutableArray alloc] init];
    PXPaymentTypeChargeRule* chargeCredit = [[PXPaymentTypeChargeRule alloc] initWithPaymentMethdodId:@"payment_method_plugin" amountCharge:10.5];
    PXPaymentTypeChargeRule* chargeDebit = [[PXPaymentTypeChargeRule alloc] initWithPaymentMethdodId:@"debit_card" amountCharge:8];
    [chargesArray addObject:chargeCredit];
    [chargesArray addObject:chargeDebit];
    // [self.mpCheckout setChargeRulesWithChargeRules:chargesArray];

    // Setear Callback Cancel
    // [self setVoidCallback];

    // [self.mpCheckout discountNotAvailable];

    [self.checkoutBuilder setLanguage:@"es"];
  
    MercadoPagoCheckout *mpCheckout = [[MercadoPagoCheckout alloc] initWithBuilder:self.checkoutBuilder];

    //[mpCheckout startWithLazyInitProtocol:self];
    [mpCheckout startWithNavigationController:self.navigationController];
}

// ReviewConfirm
-(PXReviewConfirmConfiguration *)getReviewScreenConfiguration {
    PXReviewConfirmConfiguration *config = [TestComponent getReviewConfirmConfiguration];
    return config;
}

// PaymentResult
-(PXPaymentResultConfiguration *)getPaymentResultConfiguration {
    PXPaymentResultConfiguration *config = [TestComponent getPaymentResultConfiguration];
    return config;
}

// Procesadora
-(PXPaymentConfiguration *)getPaymentConfiguration {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"PaymentMethodPlugins" bundle:[NSBundle mainBundle]];
    PaymentPluginViewController *paymentProcessorPlugin = [storyboard instantiateViewControllerWithIdentifier:@"paymentPlugin"];
    self.paymentConfig = [[PXPaymentConfiguration alloc] initWithPaymentProcessor:paymentProcessorPlugin];
    [self addPaymentMethodPluginToPaymentConfig];
    return self.paymentConfig;
}

-(void)addPaymentMethodPluginToPaymentConfig {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"PaymentMethodPlugins" bundle:[NSBundle mainBundle]];

    PXPaymentMethodPlugin * bitcoinPaymentMethodPlugin = [[PXPaymentMethodPlugin alloc] initWithPaymentMethodPluginId:@"account_money" name:@"Bitcoin" image:[UIImage imageNamed:@"bitcoin_payment"] description:@"Hola mundo"];

    [self.paymentConfig addPaymentMethodPluginWithPlugin:bitcoinPaymentMethodPlugin];
}

-(void)setVoidCallback {}

-(void)setCheckoutPref_CreditCardNotExcluded {
    Item *item = [[Item alloc] initWithTitle:@"title" quantity:2 unitPrice:2.0];
    Item *item2 = [[Item alloc] initWithTitle:@"title" quantity:2 unitPrice:2.0];

    NSArray *items = [NSArray arrayWithObjects:item, item2, nil];

    self.pref = [[PXCheckoutPreference alloc] initWithSiteId:@"MLA" payerEmail:@"sara@gmail.com" items:items];
    [self.pref addExcludedPaymentType:@"ticket"];
}

-(void)setCheckoutPref_WithId {
    self.pref = [[PXCheckoutPreference alloc] initWithPreferenceId: @"242624092-2a26fccd-14dd-4456-9161-5f2c44532f1d"];
}


-(IBAction)startCardManager:(id)sender  {}

- (void)didFinishWithCheckout:(MercadoPagoCheckout * _Nonnull)checkout {
    [checkout startWithNavigationController:self.navigationController];
}

- (void)failureWithCheckout:(MercadoPagoCheckout * _Nonnull)checkout {
    NSLog(@"LazyInit - failureWithCheckout");
}

@end
