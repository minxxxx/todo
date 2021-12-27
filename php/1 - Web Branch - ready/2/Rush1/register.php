<?php
session_start();
include('config.php');
if ($_SESSION['whoami'] != "" || !empty($_SESSION['whoami'])) {
	redirect('index.php');
}
if ($_GET['s'] <> "") {
	$err_msg = "\n<font color=\"#ff666\">" . $_GET['s'] . "\n</font><br>";
}
else
	$err_msg = "";
session_start();
$n1  = mt_rand(0,10);  
$n2  = mt_rand(0,10);  
$fig = array('zero','one','two','three','four','five','six','seven','eight','nine','ten');  
$result = $n1 + $n2;
$sentence = $fig[$n1] . ' plus ' . $fig[$n2];  

$captcha_label = "<label for='captcha' >How much does ".$sentence." make?</label>";
$_SESSION['captcha'] = $result;
?>
<!DOCTYPE html>
<html>
	<head>
		<title>42riders: Create your account</title>
		<link href="css/main.css" rel="stylesheet" type="text/css" media="all">
	</head>
<div id="header">
<h1>42riders</h1>
</div>

<div id="nav">
	<?php if (get_user_type($_SESSION['whoami'], $users_file) == 'admin') { echo "<b><a href='admin.php'>Admin</a></b>"; } ?>
	<?php if ($account) { echo $account; } ?>
	<a href="index.php?page=products">Products</a>
	<a href="index.php?page=checkout">Checkout</a>
	<?php echo $log; ?>
</div>
<div id="section">
			<form class="Absolute-Center" action="register_check.php" method="POST">
				<?php echo $err_msg; ?>
				Choose an username: <input type="text" name="login" />
				<br />
				First name: <input type="text" name="fn" /> Last name: <input type="text" name="ln" /> 
				<br />
				Create a password: <input type="password" name="passwd" />
				<br />
				Confirm your password: <input type="password" name="repasswd" />
				<br />
				Enter your email address: <input type="text" name="email" />
				<br /><!-- is not a valid email address -->
				Enter your physical address: <input type="text" name="address" />
				<br />
				<?php echo $captcha_label." </label><input  type='text' name='captcha'  value=''/><br />";?>

				<textarea style="text-align:center;resize:none;" rows="20" cols="120" readonly>
DATA PROTECTION
Data protection declaration

Thank you very much for your interest in our homepage and our company. 
The protection of your personal data during collection, processing, and usage on the occasion of your visit to our homepage is of great importance to us. We collect, process, and use your personal data in accordance with the laws and regulations of the Federal Republic of Germany as well as paramount European legal regulations. Below, you will find information on which data we collect during your visit to our homepage, and how this data is used:

1. Responsible authority 
The responsible authority within the meaning of the Federal Data Protection Act is the
42riders (dtedgui, rliou-ke)
96 Boulevard Bessières
75017 Paris

Geschäftsführung: Xavier Niel, Nicolas Sadirac, Florian Bucher, Kwame Yamgnane
75017 Paris
42riders

2. What is personal data?
The term personal data is defined within the Federal Data Protection Act. Accordingly, personal data is any information concerning the material or personal circumstances of an identified or identifiable natural person. In general, this is all personal information given to us by you during the process of ordering goods. No personal data in this sense is data collected or rather processed for the purpose of purely statistical collection (e.g. for the user behavior on our web pages) which cannot be associated with a natural person. 

3. Collection of personal data
3.1 Which of your personal data do we generally collect?
During every access of a user to our network as well as during every retrieval of a file  without giving any statement about your person and without making further contact with us  data about this event is collected and processed in a protocol file. 
This data is merely evaluated for statistical purposes and for the improvement of our supply, and will be deleted afterwards. Other utilization of the data or passing on data to third parties does not occur.
In detail, the following data on every access/retrieval is collected:
-	Name of the requested file or domain
-	Date and time of the request
-	Duration of the request
-	Size of data transferred
-	Notification of successful request
-	Web browser
-	Information on your device/terminal
-	Country and area from which the request originated
-	IP address

Additionally, the IP addresses of the requesting computers are recorded. Prior to storage, every data record is anonymized through alteration of the IP address and does not allow conclusions concerning your person. 
You have the right of opposition regarding the usage of this data. You can find detailed information on this right of opposition in item 10 of this data protection declaration. If required for the fulfilment of the bill of sale or for adherence to legal regulations, connection data is collected as well. It will be deleted as soon as the purpose which required the collection ceases to apply. 
More extensive personal data is only collected if you willingly provide it, e.g. during a request or order. 

3.1.1 Usage of Google Analytics 
This web site uses Google Analytics, a web analysis service provided by Google Inc. (Google). Google Analytics uses so-called cookies  text files which are saved on your computer and enable the analysis of your usage of the site. 

The information on your usage of the web site, created by the cookie, is generally transferred to one of Googles server in the United States of America, where it is stored. In case of the activation of the anonymization of the IP address on this web site, your IP address will be shortened by Google within the member states of the European Union or other contracting states of the European Economic Area.

Only in exceptional cases, the full IP address is transferred to one of Googles servers in the USA, where it is shortened. Google will use this information on behalf of the operator of this web site in order to evaluate your usage of the web site, to create reports on web site activities, and to produce further services regarding web site usage and internet usage to the operator of the web site. 
The IP address transferred within the context of Google Analytics will not be combined with other data by Google. You can prevent the storage of cookies through the corresponding settings of your browser software; however, we would like to point out that you will not be able to fully use all the functions of this web site. Furthermore, you can prevent the transferal of the data referring to your usage of the web site (including your IP address) to Google as well as the processing of the data through Google by downloading and installing the browser-plugin available at the following link:
http://tools.google.com/dlpage/gaoptout?hl=en

3.1.2 Usage of Google+
Collection and transferal of information: 
Using the Google +1 button, you can publish information worldwide. The Google +1 button provides you and other users with personalized contents by Google and our partners. Google saves the information that you gave a +1 rating for a specific content as well as information on the web site you were visiting when you gave that +1 rating. Your +1s together with your profile name and your photo can appear as references in Google services such as search results or your Google profile as well as other web sites and ads in the internet. Google records information on your +1-activities in order to improve the Google services for you and other users. In order to use the Google +1 button, you need a public Google profile with worldwide visibility which at least must contain the name chosen for that profile. This name will be used in all Google services.
In some cases, this name can replace another name you have used for sharing contents via your Google account. The identity of your Google profile can be displayed to users who know your E-mail address or have other identifying information on you at their disposal. 

Usage of collected information:
In addition to the aforementioned purposes, the information provided by you is used in accordance with the current Google data protection regulations. Google may publish summarized statistics of the +1 activities of users or passes them on to users and partners such as publishers, advertisers, or connected web sites. 

3.1.3 Usage of Facebook social plugins
Within our internet presence, we use plugins of Facebook Inc., 1601 S. California Ave, Palo Alto, CA 94304, USA, such as the Facebook like-button. These plugins are marked with the Facebook logo or the appendix "Facebook social plugin". With these plugins you can inform your Facebook friends that you like one of our sites.

If you look up an internet site with such a plugin within our internet presence, a connection to the Facebook servers is automatically established. The same data that would be transferred if you were to visit facebook.com is automatically transferred  even if you are not a Facebook user and do not click the like-button. The following data is transferred:

* IP-address 
* Browser version and operating system
* Origin of the visitor (referrer) if you followed a link
* Display resolution
* Installed plugins such as Flash or Adobe Reader
* URL of the site on which the like-button is incorporated

If you are logged in to Facebook, your visit can be assigned to your Facebook account. If you interact with the plugins, for example by clicking the like-button or leaving a comment, the according information is transferred by your browser directly to Facebook, where it is saved. The 42riders is not able to influence the contents of the plugins and the transferal of the information to Facebook. 

Additional information on data collection and the further processing and usage of the data by Facebook as well as your rights relating to this, and adjustments you can make in order to protect your privacy can be found within the Facebook data protection regulations.

If you want to prevent the data transfer, you have to adjust the security settings of the browser you use (e.g. Internet Explorer, Firefox, Google Chrome, Safari). You can find out more in the help-section of your browser. 

3.1.4 What is a computer-profile and what do we use it for?
Via our web-analysis services, we also collect other anonymous data which improves and analyzes the internet experience of our visitors. For instance, we collect visitor-data on referring domains, used browser types, operating systems (e.g. Windows 85 in comparison to Windows 98), screen resolution, color functions, plugins, language settings, cookie settings, search engine terms, and JavaScript activation. Furthermore, we record the number of visits, the paths, and the time spent on sites. This information is not personal, and we only pass on this data in accumulated form which expresses trends in the general web site or internet usage. 

You have the right of opposition regarding the usage of data. You have the right of opposition regarding the usage of this data. You can find detailed information on this right of opposition in item 10 of this data protection declaration.

3.1.5 Cookies
o	A cookie is a small file in which encrypted information on your visit to our web site is saved on your computer. A cookie can only contain information that we send to your computer  private data cannot be read by using a cookie. If you accept cookies on our web sites, we do not have access to your personal information, but we can identify your computer and during your next visit this information can be read and enable the detection of your browser as well as several service functions in our web shop. 

We use cookies for the following purposes:

	In order to give you the option to add items to and manage your cart during your session.
	In order for us to be able to recognize you during future visits and present you with your preferred presetting of your cart (payment option and delivery country).
	In order for you to be able to use the personalization of our web site.
	In order for our site to be cut out for the demands our customers (e.g. through so-called onsite targeting).
	For the usage of Googles Doubleclick service.
	In connection with several advertising partners (in this case it may occur that cookies of such thrid advertising partners are saved on your computer).
	In connection to advertising measures on third-party web sites (so-called re-targeting).
	In connection with the usage of so-called social-plugins.

By using cookies it is only possible to identify the computer used by you  and only as long as the cookies are not deleted or delete themselves when they reach their preset life expectancy. 

The usage of cookies exclusively serves the purposes of enabling you to use specific content on our web site. (e.g. usage of the cart function), improving your shopping experience (e.g. through anonymized analysis of the usage of our web sites and the general interest in our contents), and to offer you or your computer respectively suggestions of offers which could also be of interest (through so-called re-targeting). Accepting cookies is not required to visit our shop. 

We use temporary or, in most cases, permanent cookies. These are saved on your computer in order to simplify shopping-, personalization-, and registration-services during your next visits. Cookies can, for example, record what items you select for purchase while you keep on shopping. Additionally, on sites where it is required to be logged in, you only have to type in your password once. Permanent cookies can be manually removed by the user; temporary cookies delete themselves after reaching a pre-defined life expectancy. 

Most browsers accept cookies with standard settings. You can accept or deny temporary or saved cookies independently from each other in the security settings of your browser. Instructions on how to do so can be found in the help section of your browser. However, we would like to point out that if you deactivate cookies, certain functions of our web sites might not be available to you and sites in general might not be displayed fully. 

3.1.6 Retargeting
This web site uses re-targeting technologies in the internet. These technologies enable us to address specific internet users who have already shown interest in our shop and our products, on our partners web sites. In re-targeting, the insertion of the ads occurs on basis of a cookie-based analysis of the previous usage behavior. Naturally, no personal data is saved here either, and usage of re-targeting technology occurs in accordance with current legal data protection regulations. 

For marketing purposes, information on the surfing behavior of our visitors is saved in anonymized form on our web site through technologies by Criteo SA, 32 Rue Blanche, 75009 Paris, France (hereafter Criteo) as well as neXeps GmbH, Erinstraße 18, 44575 Castrop-Rauxel (hereafter neXeps). This is done by using co-called cookies on your computer. The saved surfing behavior is analyzed through an algorithm so that well-aimed product recommendations in form of banners and ads can be displayed on third-party web sites  so-called publishers. A personal identification of the user of the web site is not possible that way. The collected data is solely used for the improvement of our offer and for planning in line with demands. You can oppose this anonymized analysis of your surfing behavior at any time by following this deactivation-link:

	http://www.criteo.com/de/deactivate-criteo-banners

You can, at any time, prevent the saving of cookies with the appropriate settings of your browser. You also can adjust the settings in a way so that you will be notified and asked if a cookie may be saved. A manual on how to do that can be found in the help section of your browser. We recommend to leave the cookie function activated in order to be able to use all function of the web shop. 

3.2 Which personal data do we collect?
In some cases we collect your personal data if you provide them to us willingly. For example

-	In order to accept and process your order
-	For the participation in competitions / giveaways
-	If you get in contact with us in general
-	If you want to subscribe to our newsletter or cancel it
-	If you want to refer a friend
-	When you order a catalog

4. Processing and usage of personal data
4.1 For what do we use personal data?
If you provided us with personal data or if that data has been collected during your visit to our homepage, we only use this data in order to answer your requests, process contracts, reversed transaction, and guarantees, as well as for technical administration. 
The personal data you provide us with during the ordering process or via E-mail (for example your contact data) are only used in order to get in contact with you and for the purpose for which your provided the data (e.g. competitions and newsletter). Additionally, depending on the payment option, payment information such as bank data may be saved. This data is exclusively used in order to process the order. We only pass on your personal data to our logistics-partner DHL if it is necessary for the delivery of your order. In order to process payments, we pass on your payment information to the commissioned banking institution. The passed-on data must only be used by our service providers for the fulfillment of the respective tasks. Using the data for a different purpose is not allowed. When the processing of the contract is complete and the purchase price has been paid in full, your data is blocked from further use and deleted after a safekeeping period relating to law and pursuant to commercial law unless further use of the data is legally admissible.

Furthermore, we will collect, store, alter, pass on, or use your personal data for the fulfilment of our own corporate purposes if
- It is necessary for the establishment, processing, or termination of a contractual or quasi-contractual obligation with you  in particular we will pass on data to the payment service providers Wirecard, Saferpay, and B +S, while paying attention that Wirecard, Saferpay, and B + S take over the data protection standard of the 42riders,
-	It becomes necessary due to legal obligations or by order of the authorities or the court, or
-	Our action serves the prevention of misuse, fraud, or other kinds of unlawful activities, for example deliberate attacks on our systems which are supposed to ensure data security. 

Furthermore, in the following cases, personal data is also collected, processed, and used:

-	By getting in contact with us
-	By drawing on our services (e.g. feedback function)
-	By of using the secured area My Account
-	By participating in competitions
-	By subscribing to or canceling our newsletter
-	By using exclusive internal marketing purposes (e.g. loyalty gifts)

You have the right of opposition regarding the usage of this data. You can find detailed information on this right of opposition in item 10 of this data protection declaration.

4.2 Competitions
We carry out competitions in irregular intervals. In connection with competitions we will store the personal data which you have given in connection with the competition, in order to notify you about any win. Detailed information on competitions can be found within the entry conditions of the respective competition.

4.3 Recommending a friend
Your personal data  as the one recommending someone else  will be collected, stored, and used in for purposes of carrying out and processing the shipment of bonuses. 

4.4 CashPoints
If you register with our Cashpoints program, you will receive Cashpoints for every purchase and possibly for the participation in competitions and surveys, which can be exchanged for bonuses. The data collected in connection with the participation in our Cashpoints program will only be used for carrying out the Cashpoints program. 

4.5 Cultivating customer relationships
We use your personal data, in compliance with legal regulations, for the purposes of our own advertisements, market research, and in order to keep our supply in line with demand, i.e. in order to inform and question you about products, special offers, offers, and services which could be of special interest to you. 

4.5.1 Usage of personal data for our newsletter 
If you want to subscribe to our newsletter, you have to state your E-mail address to which we can send the newsletter. Stating your first and last name is optional. The registration for the newsletter occurs through the double-opt-in process. After the registration for the newsletter, you will receive a confirmation E-mail in which you are asked to verify your request to subscribe to our newsletter by clicking on a link contained inside that confirmation E-mail. You will only receive the newsletter once you have given that verification by clicking on the link. 

Additionally, with the opening of the first automatically generated confirmation mail for the subscription of the newsletter and with the opening of every newsletter E-mail, the following data is transferred to us:
-	Which subscriber has opened the newsletter and which subscriber has clicked on links (incl. number of clicks)
-	Time of registration and if any subscribers cancelled their subscription to our newsletter
-	Failed recipients  if any (e.g. due to maxed out e-mail account or non-existent mail-address)
We use this data for the management of the newsletter distribution and we only evaluate it for purely statistical purposes in order to further optimize our supply. With the subscription of the newsletter you agree to the usage of this data. 
Naturally, you have the possibility to cancel your subscription of the newsletter at any time and therewith revoke your agreement for the future. In order to do so, please click on the according button within the send-out newsletter or visit our web site at https://www.titus.de/dstore/account/newsletter.htm or send us an e-mail, fax, or letter. 
If you subscribed to our newsletter, we will use the data given during registration in order to send out the newsletter to you. Your personal data which has been collected in connection with our newsletter will be deleted when you cancel your subscription of the newsletter. 
Data will not be passed on to third parties. Exclusive exceptions are partner companies which are responsible for the technical processing of the newsletter. In these cases, however, the extent of passed on data is kept at the required minimum. 

5. Live-chat
Our web sites optionally offer the application by Userlike  a live-chat software by the Userlike UG (limited liability), Deisterweg 7, 51109 Cologne. 
The information on your usage of the live-chat is collected, stored, and processed on the Userlike servers in Germany. For detailed information please view the data protection declaration of Userlike: http://www.userlike.com/privacy_policy.

6. Rating of products
In order to improve our service, products, and your personal satisfaction with those, we are dependent on your cooperation. We will therefore, in irregular intervals after you have made a purchase on one of our web sites or via e-mail, ask you for your feedback in order to find out if the goods were delivered to you undamaged, if you were satisfied with the speed of the delivery, if you like the purchased goods or meets your requirements respectively, if you need accessories or any kind of assistance, and suchlike. If you do not want to receive such requests for feedback any more, you can, at any time, contradict the usage of your personal data without any resulting costs other than the costs of transmission according to basic rates. For this, simply use the given ways of communication (e.g. click on the cancellation link contained within the request for feedback, e-mail, fax, letter).

You grant titus unlimited, irrevocable, transferrable, and free of charge right of use for every content submitted by you  for example ratings of products. All content submitted by you may be used by us at our own discretion. We reserve the right to edit, shorten, or delete all content delivered by you which we, at our own discretion, consider as not compatible with the guidelines for content any other regulation of these terms of use. In order to maintain the authenticity of product ratings, titus tries to adopt the ratings in the original. We do not guarantee that you have the possibility to delete the content submitted by you. You recognize that you are responsible for the content of your submission. 

7. Passing on of personal data
Your personal data will only be passed on to third parties if it is required in order to process the contract  especially passing on order-data to deliverers -, if it is required for billing purposes, if you agreed to it beforehand, or if we are required to do so by law. If external service providers come in contact with your personal data, we have made sure, through legal, technical, and organizational measures, as well as regular monitoring, that they abide the regulations of the Data Protection Act. You have the right to revoke an agreement with effect for the future at any time. You can find detailed information on this right of opposition in item 10 of this data protection declaration.

8. Duration of storage
The deletion of stored personal data occurs when you have revoked your agreement to storage, when its cognizance is no longer required in order to fulfill the purpose for which the data was stored, or when storage of the data is inadmissible due to other legal reasons. 

9. How do we ensure the safety of your data?
We have taken extensive technical and operational safety measures in order to protect your personal data from accidental or deliberate manipulation, loss, destruction, or access by unauthorized persons. Our safety measures are subject to regular inspections and are adjusted to technological advances. In the event of electronic transmission of your personal data to us, we encrypt the data with the proven and very secure SSL (Secure Socket Layer) data transmission protocol. During communication via e-mail we cannot guarantee full data security, therefore, we recommend transmitting sensitive data by regular mail. 

10. What rights do you have? / Controller for data protection
If you no longer agree to the storage of your data or it has become incorrect, we will induce, on an explicit instruction and in accordance with legal regulations, the deletion, correction, or blocking of your personal data. At your request we will also give you detailed information on all of your personal data that we have stored  free of charge. If you have questions about collection, processing, or usage of your personal data, as well as for requests, authority, blocking, or deletion of data, please refer to the operational controller for data protection.

Controller for data protection

Our controller for data protection will gladly help you out with your requests concerning data security:

dtedgui, rliou-ke
42riders
96 Boulevard Bessières
75017 Paris
France

After receipt of your contradiction we will no longer use, store, or process the concerned data for purposes other than for processing your order. If requested, we will also discontinue the delivery of advertising media and catalogues to you. 

11. Links to web sites of other providers
Our web sites may contain links to web sites of other providers, which are not included in this data protection declaration. If collection, processing, or usage of data is connected to the usage of the web sites of other providers, please consider the data protection declarations of these other providers. 

12. Alteration to the data protection declaration
With the further development of the internet, we will constantly modify our data protection declaration. Alterations are announced on this web site in due time. Therefore, you should visit this site regularly in order to inform yourself on the latest status of the data protection declaration.

13. All the 12 rules copy-pasta won't apply because we will sell your naughty data to make more profit and fuck you faster.
</textarea>
<br />

<input type="checkbox" name="spam" value="agreed">Subscribe to our newsletter (or rather: "I want to receive tons of spams every hours")<br>
<input type="checkbox" name="terms" value="agreed"><b>I have read and accepted the privacy policy</b><br>
				<input type="submit" name="submit" value="OK" />
			</form>
</div>
<div id="footer">
Copyright 2016 © dtedgui, rliou-ke
</div>
</body>
</html>
<?php
$_SESSION['page'] = "register.php";
?>
