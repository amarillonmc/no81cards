--超跃星★天外的巡死神
local s,id,o=GetID()
function s.initial_effect(c)
	--送去墓地
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
   	end     
end
function s.checkfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xca0) and c:IsLinkAbove(2) and c:IsSummonPlayer(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.checkfilter,1,nil,p) then 
        	Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1) 
        end
	end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca0) and c:IsType(TYPE_LINK)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sc=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE):Select(tp,1,1,nil):GetFirst()
        if sc then
        	Duel.HintSelection(Group.FromCards(sc))
        	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_ONFIELD)
			e1:SetTarget(s.distg1)
			e1:SetLabel(sc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(s.discon)
			e2:SetOperation(s.disop)
			e2:SetLabel(sc:GetCode())
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
            local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(0,LOCATION_MZONE)
			e3:SetTarget(s.distg2)
			e3:SetLabel(sc:GetCode())
			e3:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e3,tp)
        end
	end
end
function s.distg1(e,c)
	local code=e:GetLabel()
    if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsCode(code) 
    else
    	return c:IsCode(code) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
    end    
end    
function s.distg2(e,c)
	local code=e:GetLabel()
	return c:IsCode(code)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return re:GetHandler():IsCode(code) and rp==1-tp
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end