--海伦娜·改
function c25800085.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,25800051,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6211),1,false,false)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25800085,0))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(c25800085.eftg)
	e2:SetOperation(c25800085.efop)
	c:RegisterEffect(e2)
		--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25800085,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c25800085.descon)
	e3:SetTarget(c25800085.destg)
	e3:SetOperation(c25800085.desop)
	c:RegisterEffect(e3)
end
c25800085.toss_dice=true

function c25800085.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c25800085.efop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 then
		Duel.Draw(tp,2,REASON_EFFECT)
	   Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif dc==3 or dc==4 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif dc==6 or dc==5 then
		 Duel.Draw(tp,1,REASON_EFFECT)
		 Duel.Draw(1-tp,1,REASON_EFFECT)
		
	end
end

---2
function c25800085.descon(e,tp,eg,ep,ev,re,r,rp)
	if not c25800085.econ(e,tp,eg,ep,ev,re,r,rp) then return false end
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup()  and tc:IsSetCard(0x201) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c25800085.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c25800085.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
