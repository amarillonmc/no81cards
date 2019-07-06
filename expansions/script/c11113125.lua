--重巡舰娘 雷电
function c11113125.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11113125.ffilter,2,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,11113125)
	e1:SetCondition(c11113125.sprcon)
	e1:SetOperation(c11113125.sprop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113125,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c11113125.ngcon)
	e2:SetTarget(c11113125.ngtg)
	e2:SetOperation(c11113125.ngop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113125,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c11113125.hdcon)
	e3:SetTarget(c11113125.hdtg)
	e3:SetOperation(c11113125.hdop)
	c:RegisterEffect(e3)
end
function c11113125.ffilter(c)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()==c:GetDefense()
end
function c11113125.spfilter1(c,tp,ft)
	if c:IsRace(RACE_MACHINE) and c:GetAttack()==c:GetDefense() and c:IsAbleToHandAsCost() and c:IsCanBeFusionMaterial(nil,true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or c:IsControler(tp) then
			return Duel.IsExistingMatchingCard(c11113125.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c11113125.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end
function c11113125.spfilter2(c,tp)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()==c:GetDefense() and c:IsAbleToHandAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c11113125.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c11113125.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end
function c11113125.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11113125,0))
	local g1=Duel.SelectMatchingCard(tp,c11113125.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c11113125.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11113125,0))
	if ft>0 or tc:IsControler(tp) then
		g2=g:Select(tp,1,1,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
	end
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,g1)
end
function c11113125.ngcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function c11113125.ngfilter(c,e,tp,atk,def)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()<=atk and c:GetDefense()<=def
      	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11113125.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c11113125.ngfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetAttack(),c:GetDefense()) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11113125.ngop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11113125.ngfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c:GetAttack(),c:GetDefense())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	    local at=g:GetFirst():GetAttack()
		local df=g:GetFirst():GetDefense()
	    local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-at)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-df)
		c:RegisterEffect(e2)
	    Duel.BreakEffect()
    	Duel.NegateEffect(ev)
	end	
end
function c11113125.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c11113125.hdfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:GetAttack()==c:GetDefense() and c:IsCanBeFusionMaterial()
       	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11113125.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	    and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	    and Duel.IsExistingMatchingCard(c11113125.hdfilter,tp,LOCATION_HAND,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11113125.hdfilter,tp,LOCATION_HAND,0,2,2,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c11113125.hdop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft>0 and (g:GetCount()>0 or (g:GetCount()>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if g:GetCount()>ft then g=g:Select(tp,ft,ft,nil) end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end