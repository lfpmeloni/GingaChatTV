<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="ncl" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<regionBase>
			<region width="100%" height="100%" id="r_main" />
		</regionBase>
		<descriptorBase>
			<descriptor id="d_main" region="r_main" />
		</descriptorBase>
		<connectorBase>
			<casualConnector id="onBeginSet">
				<simpleAction role="start"/>
			</casualConnector>
			<causalConnector id="onEndAttributionStartStop">
				<simpleCondition role="onEndAttribution" />
				<compoundAction operator="seq">
					<simpleAction role="stop" max="unbounded" qualifier="par" />
					<simpleAction role="start" max="unbounded" qualifier="par" />
				</compoundAction>
			</causalConnector>
			<causalConnector id="onEndAttributionAbort">
				<simpleCondition role="onEndAttribution" />
				<simpleAction role="abort" max="unbounded" qualifier="par" />
			</causalConnector>
		</connectorBase>
	</head>
	<body id="main">
		<port id="p_main" component="m_main" />
		<media id="m_keys" type="application/x-ginga-settings">
			<property name="service.currentKeyMaster" value="m_main" />
		</media>
		<media id="m_main" src="main.lua" descriptor="d_main">
			<property name="exit" />
			<property name="restart" />
		</media>
		<link xconnector="onBeginSet">
			<bind role="start" component="m_main"/>
		</link>
		<link xconnector="onEndAttributionAbort">
			<bind role="onEndAttribution" component="m_main" interface="exit" />
			<bind role="abort" component="main" />
		</link>
		<link xconnector="onEndAttributionStartStop">
			<bind role="onEndAttribution" component="m_main" interface="restart" />
			<bind role="stop" component="m_main"/>
			<bind role="start" component="m_main"/>
		</link>
	</body>
</ncl>
