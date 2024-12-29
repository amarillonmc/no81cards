--大海爬兽 迅捷鱼龙

local s,id,o=GetID()
local zd=0x5224

function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11602000,aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),1,true,true)
	
	--AtkUp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(s.e1val)
	c:RegisterEffect(e1)
	
	--DestroyOp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
	
end

--e1
--AtkUp

function s.e1valfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.e1val(e,c)
	local g=Duel.GetMatchingGroup(s.e1valfilter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	return g:GetCount() * 200
end

--e3

function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(2347656,3),aux.Stringid(2347656,4))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end


