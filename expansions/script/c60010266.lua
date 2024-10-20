--须臾蜃气
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1)
	c:EnableReviveLimit()
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.caop)
	c:RegisterEffect(e1)
	--cost
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOKEN+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE+CATEGORY_DESTROY+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.synfilter(c)
	return (c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanBeSynchroMaterial() and c:IsLocation(LOCATION_SZONE)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
end
function cm.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1,99,smat,mg)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.fil1(c)
	return c:GetAttribute()~=0 and not c:IsType(TYPE_TUNER)
end
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag=c:GetMaterial():Filter(cm.fil1,nil)
	local ac=ag:GetFirst()
	if not ac then return end
	--if ag:GetClassCount(Card.GetAttribute)>1 then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		--ac=ag:Select(tp,1,1,nil)
	--end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(ac:GetAttribute())
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1)
end

function cm.fil3(c)
	return aux.IsCodeListed(c,60010261) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fil3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local op=aux.SelectFromOptions(tp,{true,aux.Stringid(m,1)},{true,aux.Stringid(m,2)},{true,aux.Stringid(m,3)},{true,aux.Stringid(m,4)})
			local code=60010261+op
			local token=Duel.CreateToken(tp,code)
			Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.fil4(c)
	return c:IsCode(60010261) and c:IsAbleToHand()
end
function cm.bsfil1(c)
	return c:IsCode(60010264) and c:IsFaceup()
end
function cm.bsfil2(c)
	return c:IsCode(60010265) and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil4,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fil4,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local t=0
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(cm.bsfil1,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil1,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
				if rg then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
			end
		end
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.bsfil2,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,cm.bsfil2,tp,LOCATION_SZONE,0,1,1,nil)
			if dg and Duel.Destroy(dg,REASON_EFFECT)~=0 then
				t=t+1
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
				local rg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				if rg then Duel.Destroy(rg,REASON_EFFECT) end
			end
		end
		if t~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end


