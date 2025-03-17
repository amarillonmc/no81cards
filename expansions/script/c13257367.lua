--超时空武装 主武-广域火神炮
local m=13257367
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(cm.eqlimit)
	c:RegisterEffect(e11)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.bombcost)
	e4:SetTarget(cm.bombtg)
	e4:SetOperation(cm.bombop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(cm.psop)
	c:RegisterEffect(e5)
	eflist={{"bomb",e4}}
	cm[c]=eflist
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x3352)
end
function cm.actcon(e)
	local f=tama.cosmicFighters_equipGetFormation(e:GetHandler())
	return f and ((Duel.GetAttacker() and f:IsContains(Duel.GetAttacker())) or (Duel.GetAttackTarget() and f:IsContains(Duel.GetAttackTarget())))
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec and ec:IsCanRemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST) end
	ec:RemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST)
end
function cm.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.sfilter(c,tc)
	local seq=tc:GetSequence()
	local sseq=c:GetSequence()
	local loc=tc:GetLocation()
	--场地区没有相邻的卡
	if loc==LOCATION_FZONE or c:IsLocation(LOCATION_FZONE) then return false end
	local p=tc:GetControler()
	--此卡在0~4号魔陷区里，目标阵营相同且在相邻的主要怪兽区或魔陷区时，会被选中
	if c:IsLocation(LOCATION_SZONE) then
		return c:IsControler(p) and (sseq==seq or loc==LOCATION_SZONE and math.abs(aux.GetColumn(c)-aux.GetColumn(tc))==1)
	else
		if sseq<5 then
			--此卡在0~4号怪兽区里，目标在相邻的同阵营主要怪兽区、同一纵列的同阵营魔陷区或额外怪兽区时，会被选中
			if c:IsControler(p) then
				return c:GetColumnGroup():IsContains(tc) or loc==LOCATION_MZONE and seq<5 and math.abs(sseq-seq)==1
			else
				return seq>=5 and c:GetColumnGroup():IsContains(tc)
			end
		else 
			--此卡在额外怪兽区里，目标在同一纵列的主要怪兽区时，会被选中
			return loc==LOCATION_MZONE and c:GetColumnGroup():IsContains(tc)
		end
	end
end
function cm.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	if ec then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(cm.efilter1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		ec:RegisterEffect(e4,true)
	end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,1,nil)
	if tg:GetCount()>0 then
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		local g=Duel.GetMatchingGroup(cm.sfilter,tp,0,LOCATION_ONFIELD,nil,tc)
		tg:Merge(g)
		local tc=tg:GetFirst()
		while tc do
			if tc:IsFaceup() and not tc:IsDisabled() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
			end
			tc=tg:GetNext()
		end
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function cm.psop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec:IsFaceup() and ec:IsAttackPos() and ec:IsRelateToEffect(e) then
		Duel.ChangePosition(ec,POS_FACEUP_DEFENSE)
	end
end
