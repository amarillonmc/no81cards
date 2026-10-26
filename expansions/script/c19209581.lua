--判决牢狱的独罚 杠琴子
function c19209581.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c19209581.tetg)
	e1:SetOperation(c19209581.teop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--copy trap
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetDescription(aux.Stringid(19209581,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c19209581.cptg)
	e3:SetOperation(c19209581.cpop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_DECK)
	--e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c19209581.spcon)
	e4:SetTarget(c19209581.sptg)
	e4:SetOperation(c19209581.spop)
	c:RegisterEffect(e4)
	--pendulum effect
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,19209581)
	e5:SetCondition(c19209581.thcon)
	e5:SetTarget(c19209581.thtg)
	e5:SetOperation(c19209581.thop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,19209581+1)
	e6:SetTarget(c19209581.destg)
	e6:SetOperation(c19209581.desop)
	c:RegisterEffect(e6)
end
function c19209581.pfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c19209581.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c19209581.pfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,#g,0,0)
end
function c19209581.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c19209581.pfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c19209581.cpfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0xb51) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c19209581.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.IsExistingMatchingCard(c19209581.cpfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19209581.cpfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c19209581.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c19209581.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsFaceup()
end
function c19209581.desfilter(c,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c19209581.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c19209581.desfilter,tp,LOCATION_ONFIELD,0,nil,tp,c)
	if chk==0 then return true end--c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #g>0
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209581.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sc=Duel.SelectMatchingCard(tp,c19209581.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,c):GetFirst()
	if not sc then return end
	Duel.HintSelection(Group.FromCards(sc))
	if Duel.Destroy(sc,REASON_EFFECT)==0 or not c:IsRelateToChain() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c19209581.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209581.thfilter(c)
	return c:IsSetCard(0xb51) and c:IsAbleToHand()
end
function c19209581.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209581.thfilter,tp,LOCATION_DECK,0,1,nil) and 0~=e:GetHandler():GetLeftScale() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209581.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209581.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)
	end
end
function c19209581.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsLink(1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsLink,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsLink,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19209581.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
