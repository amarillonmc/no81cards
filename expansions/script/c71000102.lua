--不知该何时结束
function c71000102.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c71000102.tg)
	e1:SetOperation(c71000102.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c71000102.c)
	c:RegisterEffect(e2)
end
function c71000102.f(c,e,tp)
	return c:IsSetCard(0xe73) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0 and c:IsType(TYPE_XYZ)
end
function c71000102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71000102.f,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71000102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71000102.f,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if g:GetCount()>0 and c:IsRelateToEffect(e) and c:IsCanOverlay() and sc then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP,0x60)
		c:CancelToGrave()
		Duel.Overlay(sc,Group.FromCards(c))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c71000102.a)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)		
	end
end
function c71000102.a(e,c)
	return not c:IsSetCard(0xe73) 
end
function c71000102.c(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end