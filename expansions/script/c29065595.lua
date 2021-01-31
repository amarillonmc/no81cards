--双龙呼争
function c29065595.initial_effect(c)
	aux.AddCodeList(c,29065577)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29065595+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c29065595.cost)
	e1:SetTarget(c29065595.target)
	e1:SetOperation(c29065595.activate)
	c:RegisterEffect(e1)	 
end
function c29065595.cofil(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c29065595.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065595.cofil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c29065595.cofil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
end
function c29065595.thfil1(c)
 local tp=c:GetControler()
	return c:IsAbleToHand() and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
	and Duel.IsExistingMatchingCard(c29065595.thfil2,tp,LOCATION_DECK,0,1,c)
end
function c29065595.thfil2(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON)
end
function c29065595.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) 
end
function c29065595.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065595.thfil1,tp,LOCATION_DECK,0,1,nil) end
end
function c29065595.spfil(c,e,tp)
	return (c:IsRace(RACE_DRAGON) or c:IsCode(29065577)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29065595.fcheck(c,g) 
	return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule()) 
end 
function c29065595.fselect(g) 	
return not g:IsExists(c29065595.fcheck,1,nil,g) and g:IsExists(c29065595.thfil2,1,nil)
end
function c29065595.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065595.thfil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=1 then
	local hg=Duel.GetMatchingGroup(c29065595.thfil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=hg:SelectSubGroup(tp,c29065595.fselect,false,2,2,e,tp)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.IsExistingMatchingCard(c29065595.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(29065595,0)) then
	tc=Duel.SelectMatchingCard(tp,c29065595.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c29065595.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function c29065595.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x87af) and (re:GetHandler():IsType(TYPE_MONSTER))
end