--妖·斩·扇！
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16170120)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--盖放回合发动
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(s.actcost)
	c:RegisterEffect(e2)        
end
function s.thfilter(c,e,tp)
	local b1=c:IsFaceup() and c:IsCode(16170120) and c:IsAbleToHand() and c:IsControler(tp)
    local b2=c:IsControler(1-tp)
	return c:IsCanBeEffectTarget(e) and (b1 or b2)
end
function s.fselect(g,tp)
	return g:FilterCount(Card.IsControler,nil,tp)==1 and g:FilterCount(Card.IsControler,nil,1-tp)<=2
    	and g:GetCount()>1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,e,tp)
	if chkc then return false end
	if chk==0 then return tg:CheckSubGroup(s.fselect,2,3,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=tg:SelectSubGroup(tp,s.fselect,false,2,3,tp)
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:FilterCount(Card.IsControler,nil,tp),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:FilterCount(Card.IsControler,nil,1-tp),0,0)
    sg:KeepAlive()
	Duel.SetChainLimit(s.limit(sg))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(RESET_CHAIN)
	e1:SetCountLimit(1)
	e1:SetLabelObject(sg)
	e1:SetOperation(s.retop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.limit(g)
	return  function (e,lp,tp)
				return not g:IsContains(e:GetHandler())
			end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():DeleteGroup()
end
function s.spfilter(c,e,tp)
	return c:IsCode(16170120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:Filter(Card.IsControler,nil,tp):GetFirst()
    if tc and tc:IsRelateToEffect(e) and tc:IsControler(tp) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
    	g:RemoveCard(tc)
        local dg=g:Filter(Card.IsControler,nil,1-tp)
    	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then 
    		Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        	if sg:GetCount()==0 then return end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end    
	end
end
function s.costfilter(c)
	return aux.IsCodeOrListed(c,16170120) and not c:IsPublic()
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end