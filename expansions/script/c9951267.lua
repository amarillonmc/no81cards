--绝对魔兽战线·恩奇都
function c9951267.initial_effect(c)
   --pendulum summon
	aux.EnablePendulumAttribute(c)
	  aux.AddCodeList(c,9950528,9951267)
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
 --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xba5))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
 --attribute change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951267,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99512671)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetTarget(c9951267.attg)
	e1:SetOperation(c9951267.atop)
	c:RegisterEffect(e1)
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951267,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9951267)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c9951267.spcon)
	e2:SetTarget(c9951267.sptg)
	e2:SetOperation(c9951267.spop)
	c:RegisterEffect(e2)
 --draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(9951267,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,99512670)
	e5:SetCondition(c9951267.drcon)
	e5:SetTarget(c9951267.drtg)
	e5:SetOperation(c9951267.drop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetLabelObject(e5)
	e6:SetOperation(c9951267.regop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	e7:SetOperation(c9951267.regop2)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e8:SetOperation(c9951267.clearop)
	c:RegisterEffect(e8)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951267.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
c9951267.assault_name=9951264
function c9951267.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951267,0))
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951267,1))
end
function c9951267.spfilter2(c,e,tp)
	return c:IsCode(9951264)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c9951267.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9951267.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c9951267.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9951267.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9951267.spfilter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
function c9951267.regop(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0x9ba5) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)) or (re:GetHandler():IsSetCard(0xba5) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_TRAP))then
		local val=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(val+1)
	end
end
function c9951267.regop2(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0x9ba5) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)) or (re:GetHandler():IsSetCard(0xba5) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_TRAP)) then
		local val=e:GetLabelObject():GetLabel()
		if val==0 then val=1 end
		e:GetLabelObject():SetLabel(val-1)
	end
end
function c9951267.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c9951267.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9951267.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabel()
	if chk==0 then return d>0 and Duel.IsPlayerCanDraw(tp,d) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function c9951267.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=e:GetLabel()
	if d>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c9951267.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(rc)
end
function c9951267.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetLabel(e:GetLabel())
	e2:SetValue(c9951267.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetLabel(e:GetLabel())
	e3:SetTarget(c9951267.atktarget)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951267,0))
   Duel.Hint(HINT_SOUND,0,aux.Stringid(9951267,2))
end
function c9951267.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsAttribute(e:GetLabel())
end
function c9951267.atktarget(e,c)
	return c:IsAttribute(e:GetLabel())
end
