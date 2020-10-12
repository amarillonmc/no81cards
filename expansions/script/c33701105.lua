--.LiveVTuber Kitakami Futaba
function c33701105.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3)
	c:EnableReviveLimit()   
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701105,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(c)
	e2:SetCondition(c33701105.xyzcon)
	e2:SetOperation(c33701105.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c33701105.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33701105,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33701105.atkcost1)
	e1:SetOperation(c33701105.atkop1)
	c:RegisterEffect(e1)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33701105,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetOperation(c33701105.desop)
	c:RegisterEffect(e3)
end
function c33701105.mattg(e,c)
	return c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) and c:IsRank(7,5)
end
function c33701105.xyzcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local xc=e:GetLabelObject()
	return Duel.GetLocationCountFromEx(tp,tp,xc,e:GetHandler())>0 and xc:IsCanBeXyzMaterial(nil)
end
function c33701105.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
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
	e3:SetTarget(c33701105.splimit)
	Duel.RegisterEffect(e3,tp)
end
function c33701105.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33701105.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local x=e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST)
	e:SetLabel(x)
end
function c33701105.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(-1000*x)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
end
function c33701105.desop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetHandler():GetBattleTarget()
	if t:IsRelateToBattle() and t~=nil then
	Duel.Hint(HINT_CARD,0,33701105)
	Duel.SendtoHand(t,nil,REASON_EFFECT)
	end
end









