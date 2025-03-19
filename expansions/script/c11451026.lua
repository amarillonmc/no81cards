--幽玄百景鉴＊灵枢演谶
local cm,m=GetID()
cm.IsFusionSpellTrap=true
function cm.initial_effect(c)
	--fusion set
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,63,true)
	--gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(m)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCode(EVENT_ADJUST)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(cm.adop)
	c:RegisterEffect(e7)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(cm.condition4)
	e3:SetOperation(cm.operation4)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e5)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsLevelAbove(1) and (not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(0,1,1)+Duel.GetFieldGroup(0,0xff,0xff)
	g=g:Filter(function(c) return c:IsType(TYPE_SPIRIT+TYPE_FLIP) and c:GetFlagEffect(m)==0 end,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,0,0,1)
		local e5=Effect.CreateEffect(tc)
		e5:SetDescription(aux.Stringid(m,1))
		e5:SetCategory(CATEGORY_SUMMON)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
		e5:SetCondition(cm.condition)
		e5:SetCost(cm.cost)
		e5:SetTarget(cm.sptg)
		e5:SetOperation(cm.spop)
		tc:RegisterEffect(e5,true)
	end
end
function cm.spfilter(c)
	return c:IsHasEffect(m) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 and e:GetHandler():IsType(TYPE_SPIRIT+TYPE_FLIP) and Duel.GetFlagEffect(tp,m+0xffffff+e:GetHandler():GetLevel())==0 end
	Duel.RegisterFlagEffect(tp,m+0xffffff+e:GetHandler():GetLevel(),RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	for i=1,Duel.GetCurrentChain() do
		local te,tlv=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LEVEL)
		if te:IsActiveType(TYPE_MONSTER) and lv>0 and lv~=tlv then
			return true
		elseif te:IsActiveType(TYPE_MONSTER) and tlv>0 then
			lv=tlv
		end
	end
	return false
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_PROC)
		e3:SetCondition(cm.ntcon)
		e3:SetValue(SUMMON_TYPE_NORMAL)
		local res=c:IsMSetable(true,e3)
		return res
	end
	local g=Group.CreateGroup()
	for i=1,Duel.GetCurrentChain()-1 do
		local te,tlv=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LEVEL)
		local tc=te:GetHandler()
		if te:IsActiveType(TYPE_MONSTER) and tlv>0 and tc:IsLocation(LOCATION_HAND) then
			g:AddCard(tc)
		end
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local ev0=Duel.GetCurrentChain()
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_QUICK_F)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1)
		e1:SetLabel(ev0)
		e1:SetValue(m)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
		e1:SetTarget(cm.sptg2)
		e1:SetOperation(cm.spop)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1,true)
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_PROC)
		e3:SetCondition(cm.ntcon)
		e3:SetValue(SUMMON_TYPE_NORMAL)
		local res=c:IsMSetable(true,e3)
		return res
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	--Duel.SetChainLimit(function(e) return e:GetValue()~=m end)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetRange(LOCATION_HAND)
	e3:SetCode(EFFECT_SET_PROC)
	e3:SetCondition(cm.ntcon)
	e3:SetValue(SUMMON_TYPE_NORMAL)
	--c:RegisterEffect(e3,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local s2=c:IsMSetable(true,e3)
	if s2 then
		Duel.MSet(tp,c,true,e3)
	end
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.sfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup()
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #sg>0 and Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
			local rg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			for tc in aux.Next(rg) do
				local e1=nil
				local _CRegisterEffect=Card.RegisterEffect
				function Card.RegisterEffect(c,e,...)
					if e:GetType()&0x801==0x801 and (e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_FLIP) and e:GetOperation() then pcall(e:GetOperation(),e,c:GetControler()) end
					if e:IsHasType(EFFECT_TYPE_TRIGGER_F) and e:GetCode()==EVENT_PHASE+PHASE_END then e1=e:Clone() end
					return true
				end
				Duel.CreateToken(tp,tc:GetOriginalCode())
				Card.RegisterEffect=_CRegisterEffect
				if e1 then
					Debug.Message(e1:GetCode())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
					e1:SetCode(EVENT_CUSTOM+m)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCountLimit(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1,true)
				end
			end
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
		end
	end
end