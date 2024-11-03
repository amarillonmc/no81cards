--无身无忆无迹之人·东风谷早苗
local cm,m=GetID()
function c23400103.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,3,cm.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.mvtg)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.fit)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--indes
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.fit)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(cm.reptg)
	e4:SetValue(cm.repval)
	e4:SetOperation(cm.repop)
	c:RegisterEffect(e4)
end
function cm.fit(e,c)
	return c:IsType(TYPE_RITUAL) and e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function cm.filter(c,tp)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function cm.filter2(c,mc)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and aux.IsCodeListed(mc,c:GetCode())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)	
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			else
			Duel.ConfirmCards(1-tp,g)
			end
		else
		Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.filter0(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsLevelBelow(8)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)  end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  not c:IsImmuneToEffect(e) and Duel.MoveToField(c,tp,c:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		local g=Duel.SelectMatchingCard(tp,cm.filter0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		local tc=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.tgcon)
		e1:SetOperation(cm.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local t1,t2=e:GetLabel()
	if tc:GetFlagEffectLabel(m)~=t1 then
		e:Reset()
		return false
	else return Duel.GetTurnCount()~=t2 end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
		and c:IsOnField()  and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end