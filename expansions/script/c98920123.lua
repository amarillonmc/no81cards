--霸王烈龙 异色眼烈火龙-霸王
function c98920123.initial_effect(c)
	c:SetSPSummonOnce(98920123)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c98920123.ovfilter,aux.Stringid(98920123,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98920123.regcon)
	e2:SetOperation(c98920123.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c98920123.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c98920123.effcon)
	e4:SetTarget(c98920123.destg)
	e4:SetOperation(c98920123.desop)
	c:RegisterEffect(e4)
--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920123,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c98920123.pencon)
	e5:SetTarget(c98920123.pentg)
	e5:SetOperation(c98920123.penop)
	c:RegisterEffect(e5)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920123,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920123.sptg)
	e1:SetOperation(c98920123.spop)
	c:RegisterEffect(e1)
end
c98920123.pendulum_level=7
function c98920123.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x99)
end
function c98920123.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x99) and mc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and not c:IsCode(98920123)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920123.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98920123.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c98920123.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c98920123.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Group.FromCards(c)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920123.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			Duel.BreakEffect()
			tc:SetMaterial(mg)
			Duel.Overlay(tc,mg)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:CompleteProcedure()
				if Duel.IsExistingMatchingCard(c98920123.matfilter,tp,LOCATION_PZONE,0,1,nil,e)
					and Duel.SelectYesNo(tp,aux.Stringid(98920123,2)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local sg=Duel.SelectMatchingCard(tp,c98920123.matfilter,tp,LOCATION_PZONE,0,1,1,nil,e)
					Duel.HintSelection(sg)
					Duel.Overlay(tc,sg)
				end
			end
		end
	end
end
function c98920123.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c98920123.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(98920123,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920123,3))
end
function c98920123.effcon(e)
	return e:GetHandler():GetFlagEffect(98920123)>0
end
function c98920123.mfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(7)
end
function c98920123.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c98920123.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98920123.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return tc and tc:IsFaceup() and g:GetCount()>0 end	 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920123.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98920123.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c98920123.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c98920123.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end