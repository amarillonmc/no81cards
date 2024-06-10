--亚玛丽欧·维拉蒂安 心无旁骛
function c33703030.initial_effect(c)
--这张卡不能攻击，不会被选择为攻击对象，不会成为对方的效果的对象。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
--自己的基本分比对方少4000以上的场合，这张卡可以从手卡·墓地特殊召唤。
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,33703030+EFFECT_COUNT_CODE_DUEL)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCondition(c33703030.spcon)
	c:RegisterEffect(e4)
--双方准备阶段时，这张卡的原本攻击力变成这张卡的守备力的数值。
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_BASE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c33703030,atkcon)
	e5:SetValue(c:GetDefense())
	e5:SetReset(RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE)
	c:RegisterEffect(e5)
--双方战斗阶段结束时，自己回复这个回合对方受到的战斗伤害合计的基本分。
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_DAMAGE)
	e6:SetCondition(c33703030.damcon)
	e6:SetOperation(c33703030.damop)
	c:RegisterEffect(e6)
--双方战斗阶段时，以自己场上1只表侧表示的怪兽为对象，让这张卡的原本攻击力下降100的倍数才能发动。那只怪兽的攻击力·守备力在这个战斗阶段上升那个变化的数值。
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetHintTiming(0,TIMING_BATTLE_START+TIMING_DAMAGE_STEP)
	e7:SetCondition(c33703030.atkcon)
	e7:SetTarget(c33703030.atktg)
	e7:SetOperation(c33703030.atkop)
end
function c33703030.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-4000
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c33703030.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_STANDBY 
end
function c33703030.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE 
end
function c33703030.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(33703030)==0 then 
		c:RegisterFlagEffect(33703030,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1,ev)
	else
		local label=c:GetFlagEffectLabel(33703030)
		c:SetFlagEffectLabel(33703030,label+ev)
	end
	local rec=c:GetFlagEffectLabel(33703030)
	Duel.Recover(tp,rec,REASON_EFFECT)
end
function c33703030.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon(e,tp,eg,ep,ev,re,r,rp) and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
ned
function c33703030.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local at=math.floor(c:GetBaseAttack()/100)
	local pay_list = {}
	for p=1,at do
		if at>=p then table.insert(pay_list,p) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33703030,0))
	local pay=Duel.AnnounceNumber(tp,tabel.unpack(pay_list))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local pay=Duel.AnnounceNumber(tp,table.unpack(pay_list))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-pay*100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(-pay*100)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end





