--爱妮慕丝 华望的缔约
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x64a),13,true)
	--特召限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--特召规则    
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--融合召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--加入手卡    
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(s.tdcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
    if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
    	if tc:IsSetCard(0x64a) and tc:IsReason(REASON_EFFECT) then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
        end    
	end
end
function s.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x64a) and c:IsType(TYPE_FUSION)
end    
function s.sprfilter(c,fc,tp)
	return c:IsFusionSetCard(0x64a) and c:IsFusionType(TYPE_EFFECT) and c:IsAbleToGraveAsCost() 
    	and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0 and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(s.sprfilter,tp,LOCATION_MZONE,0,nil,c,tp)>0
    	and Duel.GetMatchingGroupCount(s.confilter,tp,LOCATION_MZONE,0,nil)==0
        and Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)>=7        
        and Duel.GetFlagEffect(tp,id)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x64a) and c:IsType(TYPE_PENDULUM) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex2=re:IsHasCategory(CATEGORY_DECKDES)
	return (ex1 and bit.band(dv1,LOCATION_DECK)==LOCATION_DECK) or ex2
end
function s.tdfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x64a)
    	and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function s.thfilter(c,g)
	return c:IsAbleToDeck() and g:IsExists(Card.IsAbleToHand,1,c)
end
function s.fselect(g,e,tp)
	return g:IsExists(s.thfilter,1,nil,g)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(s.fselect,2,4) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,g:GetCount()-1,tp,LOCATION_GRAVE)    
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,4)
    if not sg then return end
    Duel.HintSelection(sg)
    local hg=sg:Filter(Card.IsAbleToHand,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hc=hg:Select(tp,1,1,nil):GetFirst()
    if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) then
    	Duel.ConfirmCards(1-tp,hc)
        sg:RemoveCard(hc)
		if sg:GetCount()<=0 then return end
        if Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)~=0 then
        	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
            if og:GetCount()<=0 then return end
            if og:GetCount()>1 then
            	Duel.SortDecktop(tp,tp,og:GetCount())
            end
        end
    end    
end