--荧惑兽-羊火炬
function c46260003.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c46260003.rtg)
	e1:SetOperation(c46260003.rop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c46260003.descon)
	e2:SetTarget(c46260003.destg)
	e2:SetOperation(c46260003.desop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,46260003)
	e3:SetTarget(c46260003.thtg)
	e3:SetOperation(c46260003.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c46260003.condition)
	e4:SetTarget(c46260003.drtg)
	e4:SetOperation(c46260003.drop)
	c:RegisterEffect(e4)
end
function c46260003.filter(c,e,tp,mg)
	if bit.band(c:GetOriginalType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local tg=mg:Clone()
	if c.mat_filter then
		tg=tg:Filter(c.mat_filter,c,tp)
	else
		tg:RemoveCard(c)
	end
	local lv=c:GetOriginalLevel()
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,"Greater")
	local res=tg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,"Greater")
	aux.GCheckAdditional=nil
	return res
end
function c46260003.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c46260003.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end
function c46260003.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c46260003.filter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetOriginalLevel()
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c46260003.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_RITUAL)
end
function c46260003.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c46260003.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g and Duel.Release(g,REASON_EFFECT)>0 then
		local lv=eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_RITUAL):GetSum(Card.GetLevel)
		Duel.Damage(1-tp,lv*200,REASON_EFFECT)
	end
end
function c46260003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c46260003.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c46260003.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c46260003.drfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c46260003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46260003.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c46260003.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c46260003.drfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
