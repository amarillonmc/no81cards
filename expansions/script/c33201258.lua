--金鳞龙契 圣印安娜丽莎
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=33201258
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.spcon)
	e0:SetOperation(cm.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
cm.VHisc_DragonCovenant=true

--xyz
function cm.ovfilter(c)
	return c:IsFaceup() and c.VHisc_DragonCovenant and c:IsLevel(2)
end
function cm.gyfilter(c)
	return c.VHisc_DragonCovenant and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.gyfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_MZONE,0,1,nil) and g:GetClassCount(Card.GetCode)>4
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local mc=g:GetFirst()
	local mg=mc:GetOverlayGroup()
	if mg:GetCount()~=0 then
		Duel.Overlay(c,mg)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.Hint(24,0,aux.Stringid(m,0))
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.thfilter(c)
	return ((c.VHisc_DragonCovenant and not c:IsLevel(2)) or (c.VHisc_DragonRelics and c:IsType(TYPE_EQUIP))) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			--atk up
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(cm.atkfilter)
			e1:SetValue(400)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.atkfilter(e,c)
	return c.VHisc_DragonCovenant and c:IsType(TYPE_MONSTER)
end