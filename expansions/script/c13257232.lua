--宇宙战争兵器 量产炮 烬灭炮
local m=13257232
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--equip limit
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_EQUIP_LIMIT)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetValue(tama.cosmicBattleship_equipLimit_lightWeapon)
	c:RegisterEffect(e11)
	--immune
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_IMMUNE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCondition(cm.econ)
	e12:SetValue(cm.efilter)
	c:RegisterEffect(e12)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	eflist={{"equipment_rank",1}}
	cm[c]=eflist
	
end
function cm.econ(e)
	return e:GetHandler():GetEquipTarget()
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.value(e,c)
	return c:GetOriginalLevel()*200
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec end
	local seq=ec:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	sg:Sub(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec or not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=ec:GetSequence()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tc then g:AddCard(tc) end
	if seq==1 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
	elseif seq==3 then
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
	end
	if tc and tc:IsControler(1-tp) then g:AddCard(tc) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	sg:Sub(g)
	Duel.Destroy(sg,REASON_EFFECT)
end
