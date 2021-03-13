local m=15000280
local cm=_G["c"..m]
cm.name="星拟构梦·扑风之星 LV4"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000281)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000280)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	c15000280.self_effect1=e1
	--I cannot activate other effect
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCondition(cm.actcon)
	e2:SetOperation(cm.actop)  
	c:RegisterEffect(e2)
	--lv up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1,15010280)
	e3:SetCondition(cm.sp2con)
	e3:SetCost(cm.sp2cost)
	e3:SetTarget(cm.sp2tg)
	e3:SetOperation(cm.sp2op)
	c:RegisterEffect(e3)
	--lv up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,15010280)
	e4:SetCondition(cm.sp3con)
	e4:SetCost(cm.sp2cost)
	e4:SetTarget(cm.sp2tg)
	e4:SetOperation(cm.sp2op)
	c:RegisterEffect(e4)
end
cm.lvup={15000281}
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() and re~=c15000280.self_effect1
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(15000280,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
end
function cm.tgfilter(c)
	return c:IsSetCard(0x41) and c:IsAbleToGraveAsCost() and c:IsLevelBelow(5) and not c:IsCode(15000280)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local tc=e:GetLabelObject()
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_STANDBY)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_STANDBY,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_STANDBY)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetOperation(cm.rstop)
		c:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spfilter(c,e,tp)
	return c:IsCode(15000281) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000280)==0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
end
function cm.sp3con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000280)==0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,15000282)~=0
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end