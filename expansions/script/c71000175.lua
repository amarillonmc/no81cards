function c71000175.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c71000175.mfilter,3,3)
	 --效果②
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71000175,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c71000175.sttg)
	e2:SetOperation(c71000175.stop)
	c:RegisterEffect(e2)
	--get effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c71000175.chainop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetAbsoluteRange(tp,1,0)
	e4:SetTarget(c71000175.splimit)
	c:RegisterEffect(e4)
end
function c71000175.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end

--===== 效果①处理 =====--
function c71000175.mfilter(c)
	return c:IsLinkSetCard(0xe73)
end
--===== 效果②处理 =====--
function c71000175.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and ep==tp then
		Duel.SetChainLimit(c71000175.chainlm)
	end
end
function c71000175.chainlm(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_MONSTER)
end
function c71000175.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xe73) and c:IsSSetable()
end
function c71000175.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71000175.stfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c71000175.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c71000175.stfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end