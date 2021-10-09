--魔法骑士Beast·高能形态
function c9980849.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5bc2),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980849,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9980849)
	e1:SetCost(c9980849.cost)
	e1:SetCondition(c9980849.spcon)
	e1:SetTarget(c9980849.sptg)
	e1:SetOperation(c9980849.spop)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99808490)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCost(c9980849.cost)
	e3:SetCondition(c9980849.discon)
	e3:SetTarget(c9980849.distg)
	e3:SetOperation(c9980849.disop)
	c:RegisterEffect(e3)
	--draw(battle)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c9980849.drcon)
	e3:SetTarget(c9980849.drtg)
	e3:SetOperation(c9980849.drop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980849.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	Duel.AddCustomActivityCounter(9980849,ACTIVITY_SPSUMMON,c9980849.counterfilter)
end
function c9980849.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980849,0))
end
function c9980849.counterfilter(c)
	return c:IsSetCard(0xbca)
end
function c9980849.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9980849,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c9980849.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9980849.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xbca)
end
function c9980849.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980849.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x5bc2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980849.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c9980849.filter(chkc,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c9980849.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980849.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c9980849.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 or (sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if ft>=sg:GetCount() and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980849,2))
	end
end
function c9980849.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c9980849.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9980849.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(1000)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980849,2))
end
function c9980849.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c9980849.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9980849.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980849,1))
end