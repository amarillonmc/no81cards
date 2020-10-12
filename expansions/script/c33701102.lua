--.LiveVTuber Kakyoin Chieri
function c33701102.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)
	c:EnableReviveLimit()   
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701102,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(c)
	e2:SetCondition(c33701102.xyzcon)
	e2:SetOperation(c33701102.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c33701102.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)   
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c33701102.costchk)
	e2:SetOperation(c33701102.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0x10000000+33701102)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701102,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c33701102.atcost)
	e1:SetOperation(c33701102.negop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701102,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33701102.tgcon)
	e2:SetCost(c33701102.atcost)
	e2:SetTarget(c33701102.distg)
	e2:SetOperation(c33701102.disop)
	c:RegisterEffect(e2)	
end
function c33701102.mattg(e,c)
	return c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) and c:IsRank(4,2)
end
function c33701102.xyzcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local xc=e:GetLabelObject()
	return Duel.GetLocationCountFromEx(tp,tp,xc,e:GetHandler())>0 and xc:IsCanBeXyzMaterial(nil)
end
function c33701102.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local xc=e:GetLabelObject()
	local mg=xc:GetOverlayGroup()
	if mg:GetCount()~=0 then
	Duel.Overlay(e:GetHandler(),mg)
	end
	e:GetHandler():SetMaterial(Group.FromCards(xc))
	Duel.Overlay(e:GetHandler(),Group.FromCards(xc))
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c33701102.splimit)
	Duel.RegisterEffect(e3,tp)
end
function c33701102.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33701102.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,33701102)
	return Duel.CheckLPCost(tp,ct*e:GetHandler():GetOverlayCount()*200)
end
function c33701102.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,e:GetHandler():GetOverlayCount()*200)
end
function c33701102.atcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33701102.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c33701102.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c33701102.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c33701102.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end









