--塔隆·血魔
dofile("expansions/script/Talon.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(cm.batfilter)
	c:RegisterEffect(e4)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function cm.batfilter(e,c)
	return c:IsSummonLocation(LOCATION_GRAVE)
end

function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ac=g:GetFirst()
	local ag=Group.CreateGroup()
	for i=1,#g do
		if talon[ac:GetCode()]~=nil then
			ag:AddCard(ac)
		end
		ac=g:GetNext()
	end
	if chk==0 then return ag:GetCount()>0 end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("a")
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ac=g:GetFirst()
	local ag=Group.CreateGroup()
	for i=1,#g do
		if talon[ac:GetCode()]~=nil then
			ag:AddCard(ac)
		end
		ac=g:GetNext()
	end
	if ag:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=ag:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
		local ace=talon[sg:GetFirst():GetCode()]
		cm.ActivateEffect(ace,tp,e)
	end
end

function cm.ActivateEffect(e,tp,oe)
	local c=e:GetHandler()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		--Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end