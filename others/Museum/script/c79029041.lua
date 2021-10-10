--罗德岛·狙击干员-守林人
function c79029041.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029041,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79029041)
	e1:SetCost(c79029041.spcost)
	e1:SetTarget(c79029041.sptg)
	e1:SetOperation(c79029041.spop)
	c:RegisterEffect(e1)  
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029041,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029041)
	e2:SetCost(c79029041.xyzcost)
	e2:SetTarget(c79029041.xyztg)
	e2:SetOperation(c79029041.xyzop)
	c:RegisterEffect(e2)  
end
function c79029041.ctfil(c)
	return c:IsReleasable() and c:IsSetCard(0xa900) and Duel.GetMZoneCount(tp,c)>0
end
function c79029041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029041.ctfil,tp,LOCATION_MZONE,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c79029041.ctfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	if tc:GetSummonLocation()==LOCATION_EXTRA then 
	e:SetLabel(1)
	else 
	e:SetLabel(0)
	end
end
function c79029041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029041.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa906)
end
function c79029041.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	Debug.Message("到达目标地点。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029041,1))
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c79029041.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029041,3)) then 
	Debug.Message("组队完成。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029041,2))
	local sg=Duel.SelectMatchingCard(tp,c79029041.thfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg) 
	end
	end
end
function c79029041.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000) 
end
function c79029041.xyzfilter(c,g)
	return c:IsXyzSummonable(g)
end
function c79029041.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa906)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029041.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029041.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xa906)
	local g=Duel.GetMatchingGroup(c79029041.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Debug.Message("开火！")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029041,0))
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
