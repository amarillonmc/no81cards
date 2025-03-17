--超时空武装 副武 阴阳玉
local m=13257346
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
	e1:SetValue(400)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	
end
function cm.eqlimit(e,c)
	return not c:GetEquipGroup():IsExists(Card.IsSetCard,1,e:GetHandler(),0x6352)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--[[
--ec:装备卡,mc:怪兽卡
function isDiagonal(ec,mc)
	local eseq=ec:GetSequence()
	local mseq=mc:GetSequence()
	if eseq==5 then return false end
	local ex=0
	if mseq==5 then 
		mseq=1 
		ex=1
	elseif mseq==6 then 
		mseq=3
		ex=1
	end
	return math.abs(eseq-mseq)==1+ex
end
function cm.getDiagonalGroup(ec,mc,reflect)
	local g=Group.CreateGroup()
	g:AddCard(ec)
	g:AddCard(mc)
	local eseq=ec:GetSequence()
	local mseq=mc:GetSequence()
	local ptr=mseq
	local ex=0
	if mseq==5 then 
		mseq=1 
		ex=1
	elseif mseq==6 then 
		mseq=3
		ex=1
	end
	local toLeft=(eseq-mseq>0)
	if reflect and ((toLeft and mseq==0) or (not toLeft and mseq==4)) then toLeft=not toLeft end
	if ex==0 and toLeft and (ptr==2 or ptr==4) then
		ptr=3
		ex=1
	end
	
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) or not ec then return end
	if c:GetColumnGroup():IsContains(ec) then
		g:Merge(c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp))
	elseif isDiagonal(ec,mc) then
		g:Merge(cm.getDiagonalGroup(ec,mc))
	end
	Duel.Destroy(g,REASON_EFFECT)
end
]]
