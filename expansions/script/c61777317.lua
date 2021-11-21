--极星天 芙蕾雅
function c61777317.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c61777317.splimit)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61777317,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c61777317.syncon)
	e2:SetOperation(c61777317.synop)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c61777317.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)

	--effect gain
  if not c61777317.global_check then
	  c61777317.global_check=true
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(1,1)
	e1:SetCost(c61777317.costchk)
	e1:SetTarget(c61777317.actarget)
	e1:SetOperation(c61777317.costop)
	Duel.RegisterEffect(e1,0)

	--極神皇トール
	--negate
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(61777317,1))
	e11:SetCategory(CATEGORY_DISABLE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetLabelObject(e1)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetCountLimit(1)
	e11:SetTarget(c61777317.distg)
	e11:SetOperation(c61777317.disop)
	local e011=Effect.CreateEffect(c)
	e011:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e011:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e011:SetTargetRange(0xff,0xff)
	e011:SetTarget(aux.TargetBoolFunction(Card.IsCode,30604579))
	e011:SetLabelObject(e11)
	Duel.RegisterEffect(e011,0)
	--special summon
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(61777317,2))
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_GRAVE)
	e13:SetLabelObject(e1)
	e13:SetCountLimit(1)
	e13:SetCost(c61777317.spcost)
	e13:SetTarget(c61777317.sptg)
	e13:SetOperation(c61777317.spop)
	local e013=e011:Clone()
	e013:SetLabelObject(e13)
	Duel.RegisterEffect(e013,0)
	--damage
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(61777317,3))
	e14:SetCategory(CATEGORY_DAMAGE)
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetCode(EVENT_FREE_CHAIN)
	e14:SetRange(LOCATION_MZONE)
	e14:SetLabelObject(e1)
	e14:SetTarget(c61777317.damtg)
	e14:SetOperation(c61777317.damop)
	local e014=e011:Clone()
	e014:SetLabelObject(e14)
	Duel.RegisterEffect(e014,0)

	--極神皇ロキ
	--negate
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(61777317,4))
	e21:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_CHAINING)
	e21:SetCountLimit(1)
	e21:SetLabelObject(e1)
	e21:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCondition(c61777317.discon)
	e21:SetTarget(c61777317.distg2)
	e21:SetOperation(c61777317.disop2)
	local e021=e011:Clone()
	e021:SetTarget(aux.TargetBoolFunction(Card.IsCode,67098114))
	e021:SetLabelObject(e21)
	Duel.RegisterEffect(e021,0)
	--special summon
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(61777317,2))
	e23:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e23:SetType(EFFECT_TYPE_QUICK_O)
	e23:SetCode(EVENT_FREE_CHAIN)
	e23:SetRange(LOCATION_GRAVE)
	e23:SetCountLimit(1)
	e23:SetLabelObject(e1)
	e23:SetCost(c61777317.spcost2)
	e23:SetTarget(c61777317.sptg2)
	e23:SetOperation(c61777317.spop2)
	local e023=e021:Clone()
	e023:SetLabelObject(e23)
	Duel.RegisterEffect(e023,0)
	--salvage
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(61777317,5))
	e24:SetCategory(CATEGORY_TOHAND)
	e24:SetType(EFFECT_TYPE_QUICK_O)
	e24:SetCode(EVENT_FREE_CHAIN)
	e24:SetRange(LOCATION_MZONE)
	e24:SetLabelObject(e1)
	e24:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e24:SetHintTiming(TIMING_MAIN_END,TIMING_END_PHASE)
	e24:SetTarget(c61777317.thtg)
	e24:SetOperation(c61777317.thop)
	local e024=e021:Clone()
	e024:SetLabelObject(e24)
	Duel.RegisterEffect(e024,0)

	--極神聖帝オーディン
	--disable
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(61777317,6))
	e31:SetType(EFFECT_TYPE_QUICK_O)
	e31:SetCode(EVENT_FREE_CHAIN)
	e31:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	e31:SetRange(LOCATION_MZONE)
	e31:SetLabelObject(e1)
	e31:SetCountLimit(1)
	e31:SetOperation(c61777317.imop)
	local e031=e011:Clone()
	e031:SetTarget(aux.TargetBoolFunction(Card.IsCode,93483212))
	e031:SetLabelObject(e31)
	Duel.RegisterEffect(e031,0)
	--special summon
	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(61777317,2))
	e33:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e33:SetType(EFFECT_TYPE_QUICK_O)
	e33:SetCode(EVENT_FREE_CHAIN)
	e33:SetRange(LOCATION_GRAVE)
	e33:SetLabelObject(e1)
	e33:SetCountLimit(1)
	e33:SetCost(c61777317.spcost3)
	e33:SetTarget(c61777317.sptg3)
	e33:SetOperation(c61777317.spop3)
	local e033=e031:Clone()
	e033:SetLabelObject(e33)
	Duel.RegisterEffect(e033,0)
	--draw
	local e34=Effect.CreateEffect(c)
	e34:SetDescription(aux.Stringid(61777317,7))
	e34:SetCategory(CATEGORY_DRAW)
	e34:SetType(EFFECT_TYPE_QUICK_O)
	e34:SetCode(EVENT_FREE_CHAIN)
	e34:SetLabelObject(e1)
	e34:SetRange(LOCATION_MZONE)
	e34:SetHintTiming(TIMING_MAIN_END,TIMING_END_PHASE)
	e34:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e34:SetTarget(c61777317.drtg)
	e34:SetOperation(c61777317.drop)
	local e034=e031:Clone()
	e034:SetLabelObject(e34)
	Duel.RegisterEffect(e034,0)
  end

end
function c61777317.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x3042)
end
function c61777317.synfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsAttribute(lc:GetAttribute()) and c:IsSetCard(0x42)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c61777317.syncon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c61777317.synfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function c61777317.synop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c61777317.synfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_SYNCHRO)
end
function c61777317.mattg(e,c)
	return c:IsSetCard(0x4b) and c:IsType(TYPE_SYNCHRO)
end



function c61777317.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(c61777317.rthfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c61777317.rthfilter(c)
	return c:IsCode(61777317) and not c:IsForbidden() and not c:IsDisabled() and c:IsAbleToHand()
end
function c61777317.actarget(e,te,tp)
	return te:GetLabelObject()==e
end
function c61777317.costop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	--local g=Duel.SelectMatchingCard(tp,c61777317.rthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local g=Duel.GetMatchingGroup(c61777317.rthfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g:GetFirst(),nil,REASON_EFFECT)
	end
end
	--極神皇トール
function c61777317.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c61777317.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c61777317.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPreviousPosition()
	if c:IsReason(REASON_BATTLE) then pos=c:GetBattlePosition() end
	if rp==1-tp and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(pos,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(61777317,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c61777317.cfilter(c)
	return c:IsSetCard(0x6042) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c61777317.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61777317.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c61777317.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c61777317.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c61777317.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c61777317.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c61777317.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end



	--極神皇ロキ
function c61777317.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c61777317.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c61777317.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c61777317.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPreviousPosition()
	if c:IsReason(REASON_BATTLE) then pos=c:GetBattlePosition() end
	if rp==1-tp and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(pos,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(61777317,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c61777317.cfilter2(c)
	return c:IsSetCard(0xa042) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c61777317.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61777317.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c61777317.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c61777317.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c61777317.spop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c61777317.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c61777317.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c61777317.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61777317.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c61777317.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c61777317.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end


	--極神聖帝オーディン
function c61777317.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c61777317.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c61777317.imfilter(e,re)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c61777317.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=c:GetPreviousPosition()
	if c:IsReason(REASON_BATTLE) then pos=c:GetBattlePosition() end
	if rp==1-tp and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(pos,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(61777317,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c61777317.cfilter3(c)
	return c:IsSetCard(0x3042) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c61777317.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61777317.cfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c61777317.cfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c61777317.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c61777317.spop3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function c61777317.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c61777317.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
