--方舟骑士-令
c29002022.named_with_Arknight=1
function c29002022.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),12,12,c29002022.ovfilter,aux.Stringid(29002022,0),12,c29002022.xyzop)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29002022,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetCost(c29002022.spcost)
	e1:SetTarget(c29002022.sptg)
	e1:SetOperation(c29002022.spop)
	c:RegisterEffect(e1)
	--change 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_SOLVING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c29002022.cgcon) 
	e2:SetOperation(c29002022.cgop) 
	c:RegisterEffect(e2)
end
function c29002022.ovfilter(c)
	local tp=c:GetControler()
	local x=Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)
	return c:IsFaceup() and x>=12 and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c29002022.xyzop(e,tp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29002022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29065548,0,TYPES_TOKEN_MONSTER,2000,2000,12,RACE_WYRM,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29002022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29065548,0,TYPES_TOKEN_MONSTER,2000,2000,12,RACE_WYRM,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,29065548)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c29002022.rlfil(c) 
	return c:IsType(TYPE_TOKEN) and c:IsReleasable() 
end 
function c29002022.cgcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065548) and Duel.IsExistingMatchingCard(c29002022.rlfil,tp,LOCATION_MZONE,0,1,nil)
end  
function c29002022.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c29002022.repop)   
end 
function c29002022.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29002022) 
	local g=Duel.GetMatchingGroup(c29002022.rlfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.Release(sg,REASON_EFFECT)
	end 
end




