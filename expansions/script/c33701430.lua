--ELPOD
local m=33701430
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33701424)
	--change code
	aux.EnableChangeCode(c,33701424,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.damval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.damtg)
	e3:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	
end
function cm.damval(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 and re then
		local rc=re:GetHandler()
		if (rc:IsSetCard(0x9449) or rc:IsCode(33701424)) and rc~=e:GetHandler() then
			return val*2
		end
	end
	return val
end
function cm.damtg(e,c)
	return (rc:IsSetCard(0x9449) or rc:IsCode(33701424)) and rc~=e:GetHandler()
end
function cm.filter(c)
	return c:IsSetCard(0x9449) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
	
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Damage(tp,tc:GetDefense(),REASON_EFFECT)>0 then
		local t1=tc:IsAbleToHand()
		local t2=tc:IsAbleToGrave()
		local op=0
		if t1 or t2 then
			local m={}
			local n={}
			local ct=1
			if t1 then m[ct]=aux.Stringid(m,0) n[ct]=1 ct=ct+1 end
			if t2 then m[ct]=aux.Stringid(m,1) n[ct]=2 ct=ct+1 end
			m[ct]=aux.Stringid(m,2) n[ct]=3 ct=ct+1
			local sp=Duel.SelectOption(tp,table.unpack(m))
			op=n[sp+1]
		end
		if op==1 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		elseif op==2 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
