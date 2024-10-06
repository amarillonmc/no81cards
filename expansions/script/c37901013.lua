--机娘·「破灭」
local m=37901013
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ff,5,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_MATERIAL):SetValue(SUMMON_VALUE_SELF)
--e1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep==1-tp
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
--e2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,m-1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep==1-tp and Duel.GetCurrentChain()==0
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateSummon(eg)
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end)
	c:RegisterEffect(e2)
--e3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+8)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(cm.t3)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not cm.t3(e,tp,eg,ep,ev,re,r,rp,0) then return end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsControler(tp) then
			local seq=c:GetSequence()
			if seq>4 then return end
			if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
				or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
				local flag=0xff
				if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag & ~(0x1 << seq-1) end
				if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag & ~(0x1 << seq+1) end
				Duel.Hint(HINT_SELECTMSG,tp,571)
				local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
				local nseq=math.log(s,2)
				Duel.MoveSequence(c,nseq)
			end
			local g=c:GetColumnGroup():Filter(function(c) return c:IsControler(1-tp) end,nil)
			if #g>0 then
				Duel.BreakEffect()
				for tc in aux.Next(g) do
					if tc:IsFaceup() and not tc:IsDisabled() then
						Duel.NegateRelatedChain(tc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e1)
						local e2=e1:Clone()
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_EVENT+0x1fe0000)
						tc:RegisterEffect(e2)
					end
				end
				Duel.AdjustInstantly()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end)
	c:RegisterEffect(e3)
end
function cm.ff(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x388)
		and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x388):IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
--e3
function cm.t3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local seq=e:GetHandler():GetSequence()
		if seq>4 then return false end
		return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
	end
end