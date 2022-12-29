--于黄昏中窥见真实
local m=60000091
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,13,false)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	--changeatt
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,160000091)
	e3:SetCost(cm.cacost)
	e3:SetTarget(cm.catg)
	e3:SetOperation(cm.caop)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,163477791)
	e4:SetTarget(cm.retg)
	e4:SetOperation(cm.reop)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(cm.recon)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.spcon)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end

function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x628) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())) and c:IsType(TYPE_MONSTER)
end

function cm.getfusionfilter(c,tp,tc)
	return c:IsPosition(POS_FACEDOWN) and c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0x628) and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0
end

function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.getfusionfilter,tp,LOCATION_ONFIELD,0,nil,tp,c)
	return g:GetCount()>0
end

function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.getfusionfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil)
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			Duel.SendtoDeck(tc,nil,2,REASON_COST)
		end
	end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+EVENT_SPSUMMON_NEGATED,0,1)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		e:GetHandler():CompleteProcedure()
		e:GetHandler():ResetFlagEffect(m)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x628)
end

function cm.costcfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsCode(m) and c:IsFaceup() and c:IsSetCard(0x628) and c:IsAbleToHandAsCost()
end

function cm.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message(Duel.IsExistingMatchingCard(cm.costcfilter,tp,LOCATION_ONFIELD,0,1,nil))
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costcfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.costcfilter,tp,LOCATION_ONFIELD,0,nil,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:Select(tp,1,1,nil)
	Duel.HintSelection(tc)
	Duel.SendtoHand(tc,nil,REASON_COST)
end

function cm.tgcfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x628)
end

function cm.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message(Duel.IsExistingMatchingCard(cm.tgcfilter,tp,LOCATION_EXTRA,0,1,nil))
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
	
function cm.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(cm.tgcfilter,tp,LOCATION_EXTRA,0,1,nil) then
		local g=Duel.GetMatchingGroup(cm.tgcfilter,tp,LOCATION_EXTRA,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=g:Select(tp,1,1,nil)
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) and c:IsRelateToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetValue(ATTRIBUTE_LIGHT)
			c:RegisterEffect(e2)
		end
	end
end

function cm.tgrfilter(c)
	return c:IsSetCard(0x628) and c:IsAbleToGrave()
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgrfilter,tp,LOCATION_REMOVED,0,1,c) and c:IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_REMOVED)
end
	
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.tgrfilter,tp,LOCATION_REMOVED,0,1,c) 
	and c:IsAbleToGrave() then
		local g=Duel.GetMatchingGroup(cm.tgrfilter,tp,LOCATION_REMOVED,0,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=g:Select(tp,1,1,nil)
		if g1 then g1:AddCard(c) end
		Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)
	end
end

function cm.recon(e)
	return e:GetHandler():IsFaceup()
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000052)==0 end
	Duel.RegisterFlagEffect(tp,60000052,RESET_CHAIN,0,1)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(60000043)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end