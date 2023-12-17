--深海姬·喷吐虎鲸
function c13015714.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,c13015714.lcheck)
	c:EnableReviveLimit() 
	--to deck and draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,13015714+EFFECT_COUNT_CODE_DUEL) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c13015714.tddtg) 
	e1:SetOperation(c13015714.tddop) 
	c:RegisterEffect(e1)  
	--remove des sp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_MZONE)   
	e2:SetCountLimit(1,23015714)
	e2:SetTarget(c13015714.rdsptg) 
	e2:SetOperation(c13015714.rdspop) 
	c:RegisterEffect(e2) 
end
function c13015714.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xe01)
end 
function c13015714.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	
end 
function c13015714.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local x=Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
		if x>0 and Duel.IsPlayerCanDraw(tp,x) then 
			Duel.Draw(tp,x,REASON_EFFECT)   
		end   
	end  
end 
function c13015714.rdsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsAbleToRemove() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xe01) end,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsAbleToRemove() and c:IsSetCard(0xe01) end,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
  
end
function c13015714.chlimit(e,ep,tp)
	return tp==ep
end
function c13015714.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsSetCard(0xe01) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0   
end 
function c13015714.rdspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xe01) end,tp,LOCATION_ONFIELD,0,1,nil) then 
		local dg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and c:IsSetCard(0xe01) end,tp,LOCATION_ONFIELD,0,1,1,nil) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c13015714.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(13015714,0)) then 
			local sg=Duel.SelectMatchingCard(tp,c13015714.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)   
			Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)   
		end 
	end 
end
