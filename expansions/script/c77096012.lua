--究极可爱伊丽神·笑
function c77096012.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,77096005,77096007,77097291,77032549,77096011) 
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2) 
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77096012,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c77096012.copycost)
	e2:SetTarget(c77096012.copytg)
	e2:SetOperation(c77096012.copyop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(function(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() end)
	e3:SetCost(c77096012.spcost)
	e3:SetTarget(c77096012.sptg)
	e3:SetOperation(c77096012.spop)
	c:RegisterEffect(e3)
end
function c77096012.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(41209827)==0 end
	e:GetHandler():RegisterFlagEffect(41209827,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c77096012.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and c:IsFaceup() 
end
function c77096012.copytg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c77096012.copyfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77096012.copyfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c77096012.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local code=tc:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(77096012,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetOperation(c77096012.rstop)
		c:RegisterEffect(e3)
	end 
end
function c77096012.rstop(e,tp,eg,ep,ev,re,r,rp)
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
function c77096012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c77096012.spfilter(c,e,tp)
	return c:IsCode(77096005,77096007,77097291,77032549,77096011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77096012.spgck(g,e,tp)  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end 
	return g:GetClassCount(Card.GetCode)==g:GetCount() and Duel.GetMZoneCount(tp,e:GetHandler())>=g:GetCount()   
end 
function c77096012.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c77096012.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c77096012.spgck,5,5,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c77096012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77096012.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp) 
	if g:CheckSubGroup(c77096012.spgck,5,5,e,tp) then 
		local sg=g:SelectSubGroup(tp,c77096012.spgck,false,5,5,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 









