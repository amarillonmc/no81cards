--满开神树勇者 地守神-友奈
function c9910300.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.NonTuner(nil),nil,nil,aux.Tuner(nil),2,99)
	c:EnableReviveLimit()
	--spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(c9910300.sumsuc)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910300.tdcon)
	e3:SetTarget(c9910300.tdtg)
	e3:SetOperation(c9910300.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c9910300.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c9910300.imcon)
	e5:SetValue(c9910300.imfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c9910300.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(c9910300.atkval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MATERIAL_CHECK)
	e8:SetValue(c9910300.valcheck)
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
	--remove
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCategory(CATEGORY_REMOVE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c9910300.rmcon)
	e9:SetTarget(c9910300.rmtg)
	e9:SetOperation(c9910300.rmop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_MATERIAL_CHECK)
	e10:SetValue(c9910300.valcheck)
	e10:SetLabelObject(e9)
	c:RegisterEffect(e10)
end
function c9910300.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9910300,1))
end
function c9910300.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	e:GetLabelObject():SetLabel(ct)
end
function c9910300.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>2
end
function c9910300.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function c9910300.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c9910300.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>4
end
function c9910300.imfilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9910300.atkval(e,c)
	local ph=Duel.GetCurrentPhase()
	local tp=c:GetControler()
	if Duel.GetTurnPlayer()~=tp or not e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
		or e:GetLabel()<5 or ph<PHASE_BATTLE_START or ph>PHASE_BATTLE then return 0 end
	return e:GetLabel()*3650
end
function c9910300.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>6
end
function c9910300.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function c9910300.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,nil,POS_FACEDOWN)
	if ct>=g1:GetCount()+g2:GetCount() then return end
	if ct>=g1:GetCount() and not Duel.SelectYesNo(1-tp,aux.Stringid(9910300,0)) then
		local rg=Duel.GetDecktopGroup(1-tp,g1:GetCount()+g2:GetCount()-ct)
		Duel.DisableShuffleCheck()
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local d=g1:GetCount()-ct
		if d<=0 then d=1 end
		local rg1=g1:Select(1-tp,d,g1:GetCount()+g2:GetCount()-ct,nil)
		local rg2=Duel.GetDecktopGroup(1-tp,g1:GetCount()+g2:GetCount()-ct-rg1:GetCount())
		rg1:Merge(rg2)
		Duel.DisableShuffleCheck()
		Duel.Remove(rg1,POS_FACEDOWN,REASON_EFFECT)
	end
end
