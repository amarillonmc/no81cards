--虫融姬战国之虫融病
function c10105911.initial_effect(c) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,10105911) 
	e1:SetTarget(c10105911.actg)
	e1:SetOperation(c10105911.acop)
	c:RegisterEffect(e1)
	--to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,20105911)
	e2:SetCondition(c10105911.tdcon)
	e2:SetTarget(c10105911.tdtg)
	e2:SetOperation(c10105911.tdop)
	c:RegisterEffect(e2)
end
function c10105911.ctfil(c) 
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x8cdd) and not c:IsType(TYPE_FUSION) and c:IsType(TYPE_MONSTER)
end 
function c10105911.ctgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c10105911.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function c10105911.espfil(c,e,tp,mg) 
	return c:IsLink(mg:GetCount()) and c:IsSetCard(0x8cdd) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0   
end 
function c10105911.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10105911.ctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c10105911.ctgck,1,8,e,tp) end
	local mg=g:SelectSubGroup(tp,c10105911.ctgck,false,1,8,e,tp) 
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.SendtoDeck(mg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10105911.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject() 
	if mg and Duel.IsExistingMatchingCard(c10105911.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then  
		local sc=Duel.SelectMatchingCard(tp,c10105911.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) 
		sc:CompleteProcedure() 
	end 
end 
function c10105911.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x8cdd) and c:IsControler(tp)
end
function c10105911.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c10105911.cfilter,1,nil,tp)
end
function c10105911.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_MONSTER) 
end 
function c10105911.tdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c10105911.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105911.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(c10105911.thfil,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c10105911.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)  
	end
end

