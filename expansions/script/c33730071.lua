--键★记忆 青空 / Memoria K.E.Y - Aozora e il Cielo Blu
--Scripted by: XGlitchy30
local s,id = GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	--SS proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.con)
	e2:SetCost(s.cost)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	e0:SetLabelObject(e2)
	c:RegisterEffect(e0)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
end
function s.tgrfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function s.fselect(g,tp,sc)
	return g:GetSum(Card.GetLevel)>=13 and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(s.fselect,1,#g,tp,c)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,s.fselect,false,1,#g,tp,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(tg,REASON_COST)
	g:DeleteGroup()
end

function s.efilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetRank()<lv
		else
			return ec:GetLevel()<lv
		end
	else
		return false
	end
end

function s.excfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x460)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g and #g>0 and not g:IsExists(s.excfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<1000 or e:GetLabel()==1
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_REVERSE_DAMAGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_RECOVER)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(s.lpop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetValue(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e4)
	end
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep~=tp or r&REASON_RDAMAGE==0 then return end
	if c and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		Duel.Hint(HINT_CARD,tp,c:GetOriginalCode())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(ev)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end