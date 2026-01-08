--空创鹿鹰兽
local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function s.pfilter(c)
	return c:IsCode(40020509) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and not c:IsForbidden()
end

function s.fusfilter(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and s.HighEvo(c) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1800,500,4,RACE_WINGEDBEAST,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,1800,500,4,RACE_WINGEDBEAST,ATTRIBUTE_LIGHT) then return end
	
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	
	local b1=false
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.IsExistingMatchingCard(s.pfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) then
		b1=true
	end
	
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pg=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
		if pg:GetCount()>0 then
			Duel.MoveToField(pg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
	
	local mg=Duel.GetFusionMaterial(tp)
	local b2=false
	if Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then
		b2=true
	end
	
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.fusfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
		local tc=sg:GetFirst()
		if tc then
			tc:SetMaterial(nil)
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,tp)
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end