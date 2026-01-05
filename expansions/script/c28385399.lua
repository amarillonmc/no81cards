--闪耀的紫焰光 革命之刻
function c28385399.initial_effect(c)
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x283),2,99,true)
	c:EnableReviveLimit()
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCountLimit(1,28385399+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c28385399.hspcon)
	e0:SetOperation(c28385399.hspop)
	c:RegisterEffect(e0)
	--destroy and remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(c28385399.descon)
	e1:SetTarget(c28385399.destg)
	e1:SetOperation(c28385399.desop)
	c:RegisterEffect(e1)
	--material check
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c28385399.valcheck)
	c:RegisterEffect(ce1)
c28385399.counter_add_list={0x1283}
end
function c28385399.matfilter(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsFusionSetCard(0x283) and c:IsCanBeFusionMaterial()
end
function c28385399.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28385399.matfilter,c:GetOwner(),LOCATION_MZONE,0,nil)
	return mg:GetCount()>=2 and Duel.GetLP(c:GetOwner())<=3000
end
function c28385399.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c28385399.matfilter,tp,LOCATION_MZONE,0,2,99,nil)
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function c28385399.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(28385399)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x283) and ct and ct>0 end
	e:SetLabel(ct)
end
function c28385399.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,ct,nil,0x283)
		if #g~=0 and (g:FilterCount(Card.IsAbleToRemove,nil)<#g or Duel.SelectOption(tp,aux.Stringid(28385399,3),1192)==0) then
			Duel.Destroy(g,REASON_EFFECT)
		else
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() then c:AddCounter(0x1283,#g) end
	end
	if Duel.GetLP(tp)<=3000 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCondition(c28385399.damcon)
		e1:SetValue(c28385399.damval)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
	end
end
function c28385399.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,28385399)==0
end
function c28385399.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then
		e:GetLabelObject():Reset()
		e:Reset()
		return 0
	end
	return val
end
function c28385399.valcheck(e,c)
	c:RegisterFlagEffect(28385399,RESET_EVENT+0xff0000,0,1,c:GetMaterialCount())
end
