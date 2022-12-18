local m=15000395
local cm=_G["c"..m]
cm.name="替身名-『脸部特写』"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000395)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.secon)
	e1:SetTarget(cm.setg)
	e1:SetOperation(cm.seop)
	c:RegisterEffect(e1)
	if not cm.Talking_Head_Check then
		cm.Talking_Head_Check=true
		_Talking_Head_AnnounceCard=Duel.AnnounceCard
		function Duel.AnnounceCard(p,...)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceCard(ap,...)
		end
		_Talking_Head_AnnounceAttribute=Duel.AnnounceAttribute
		function Duel.AnnounceAttribute(p,ct,attr)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceAttribute(ap,ct,attr)
		end
		_Talking_Head_AnnounceCoin=Duel.AnnounceCoin
		function Duel.AnnounceCoin(p)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceCoin(ap)
		end
		_Talking_Head_AnnounceLevel=Duel.AnnounceLevel
		function Duel.AnnounceLevel(p,min,max,...)
			local ap=p
			if not min then min=1 end
			if not max then max=12 end
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceLevel(ap,min,max,...)
		end
		_Talking_Head_AnnounceNumber=Duel.AnnounceNumber
		function Duel.AnnounceNumber(p,num,...)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceNumber(ap,num,...)
		end
		_Talking_Head_AnnounceRace=Duel.AnnounceRace
		function Duel.AnnounceRace(p,ct,rac)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceRace(ap,ct,rac)
		end
		_Talking_Head_AnnounceType=Duel.AnnounceType
		function Duel.AnnounceType(p)
			local ap=p
			if Duel.IsPlayerAffectedByEffect(p,15000395) then ap=1-p end
			return _Talking_Head_AnnounceType(ap)
		end
	end
end
function cm.secon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD,0xe)>0 and e:GetHandler():CheckUniqueOnField(1-tp)
end
function cm.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD,0xe)>0 then
		Duel.ConfirmCards(1-tp,c)
		if Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,0xe) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e1)
			--change effect type
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(15000395)
			e2:SetRange(LOCATION_SZONE)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e2)
		end
	end
end