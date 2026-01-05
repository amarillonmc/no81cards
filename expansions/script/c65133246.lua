--幻叙幻现武装-“龙翼”推进装置
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--Equip Limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(s.eqlimit)
	c:RegisterEffect(e0)
	--Activate & SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Move & Immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_b)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(s.mvcon)
	e2:SetCost(s.mvcost)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(6)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
	end
end
function s.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler():IsControler(1-tp) 
		and Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):IsContains(ec)
end
function s.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then
		local seq=ec:GetSequence()
		return seq<5 and (Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) or Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
	end
	local seq=ec:GetSequence()
	local flag=0
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|bit.lshift(1,seq-1) end
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|bit.lshift(1,seq+1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(ec,nseq)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and ec:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		ec:RegisterEffect(e1)
	end
end
function s.efilter(e,re)
	return re==e:GetLabelObject()
end
