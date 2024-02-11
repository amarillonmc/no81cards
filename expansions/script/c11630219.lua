--乱型镜·万物崩塌
local m=11630219
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	  
end
function cm.filter(c)
	return c:IsFaceup() 
end
function cm.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g = Duel.GetMatchingGroup(cm.filter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
	local tc=g:GetFirst()
	while tc do
		local p=tc:GetControler()
		local tg=Duel.GetMatchingGroup(aux.TRUE,p,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local rg=tg:RandomSelect(tp,1)
		local rgc=rg:GetFirst()
		local code=rgc:GetCode()
		local tg2=Duel.GetMatchingGroup(cm.filter2,p,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local rg2=tg2:RandomSelect(tp,1)
		local rgc2=rg2:GetFirst()
		local race=rgc2:GetRace()
		--
		local lv = math.random(1, 12)
		local atk = math.random(0, 5000)
		local def = math.random(0, 5000)
		cm.lvtotuner(tc,code,lv,race,atk,def)
		tc=g:GetNext()
	end
end
function cm.lvtotuner(tc,code,lv,race,atk,def)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	if not (tc:IsType(TYPE_LINK) or tc:IsType(TYPE_XYZ))  then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(lv)
		tc:RegisterEffect(e2)
	elseif tc:IsType(TYPE_XYZ) then
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RANK)
		e2:SetValue(lv)
		tc:RegisterEffect(e2)
	end
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(race)
	tc:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(atk)
	tc:RegisterEffect(e4)
	if not tc:IsType(TYPE_LINK) then
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e5:SetValue(def)
		tc:RegisterEffect(e5)
	end
end
