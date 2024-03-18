--虹猫蓝兔七侠传 招式
local m=50099011
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter,1)  
	--link success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)  
end
function cm.eqfilter(c)
	return c:IsSetCard(0x999) and c:GetType()==TYPE_EQUIP+TYPE_SPELL 
end
function cm.mfilter(c)
	return c:GetEquipGroup():IsExists(cm.eqfilter,1,nil)
end
--link success
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cfilter(c,mc)
	return c:GetPreviousEquipTarget()==mc and c:IsCode(50000001,50000013,50000003,50000008,50000015,50000005,50000011)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	local mc=mg:GetFirst()
	local eg=Duel.GetMatchingGroup(cm.cfilter,tp,0xfff,0xfff,nil,mc) 
	local a1,a2,a3=0,0,0
	if eg:IsExists(Card.IsCode,1,nil,50000001,50000013) then
		a1=1
	end
	if eg:IsExists(Card.IsCode,1,nil,50000003,50000008) then
		a2=1
	end
	if eg:IsExists(Card.IsCode,1,nil,50000015,50000005,50000011) then
		a3=1
	end
	if chk==0 then return a1+a2+a3>0 end
	e:SetLabel(a1,a2,a3)
	if a1>0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
	if a2>0 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	end
	if a3>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local a1,a2,a3=e:GetLabel()
	if a1>0 then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	if a2>0 then
		Duel.Recover(tp,500,REASON_EFFECT)
	end
	if a3>0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end



