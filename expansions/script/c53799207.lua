local m=53799207
local cm=_G["c"..m]
cm.name="栞奈"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,nil,3,3,function(g,lc)return g:GetClassCount(Card.GetLinkCode)==1 end)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsAttribute(ATTRIBUTE_FIRE) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then Duel.Overlay(sc,mg) end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(function(e)return Duel.GetCurrentPhase()<PHASE_BATTLE_START or Duel.GetCurrentPhase()>PHASE_BATTLE end)
			sc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			sc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			sc:RegisterEffect(e3,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e4,true)
			Duel.SpecialSummonComplete()
		end
	end
end
