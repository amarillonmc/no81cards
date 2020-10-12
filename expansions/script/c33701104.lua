--.LiveVTuber Ushimaki Riko
function c33701104.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()   
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33701104,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(c)
	e2:SetCondition(c33701104.xyzcon)
	e2:SetOperation(c33701104.xyzop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c33701104.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)  
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c33701104.ciop)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DRAW)
	e4:SetOperation(c33701104.ciop1)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c33701104.tdcost)
	e5:SetOperation(c33701104.tdop)
	c:RegisterEffect(e5)
end
c33701104.toss_coin=true
function c33701104.mattg(e,c)
	return c:IsSetCard(0x1445) and c:IsType(TYPE_XYZ) and c:IsRank(6,4)
end
function c33701104.xyzcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local xc=e:GetLabelObject()
	return Duel.GetLocationCountFromEx(tp,tp,xc,e:GetHandler())>0 and xc:IsCanBeXyzMaterial(nil)
end
function c33701104.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
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
	e3:SetTarget(c33701104.splimit)
	Duel.RegisterEffect(e3,tp)
end
function c33701104.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c33701104.ciop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return end
	Duel.Hint(HINT_CARD,0,33701104)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(rp)
	local res=Duel.TossCoin(rp,1)
	if coin==res then
	Duel.SendtoDeck(eg,nil,0,REASON_EFFECT)
	end
end
function c33701104.ciop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW then return end
	Duel.Hint(HINT_CARD,0,33701104)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(rp)
	local res=Duel.TossCoin(rp,1)
	if coin==res then
	Duel.SendtoDeck(eg,nil,0,REASON_EFFECT)
	end
end
function c33701104.tdcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33701104.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetLabelObject(c)
	e1:SetCondition(c33701104.txcon)
	e1:SetOperation(c33701104.txop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	Duel.RegisterEffect(e2,tp)
end
function c33701104.txfil(c,xp)
	return c:IsControler(1-xp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c33701104.txcon(e,tp,eg,ep,ev,re,r,rp)
	local xp=e:GetLabelObject():GetControler()
	return eg:IsExists(c33701104.txfil,1,nil,xp)
end
function c33701104.txop(e,tp,eg,ep,ev,re,r,rp)
	local xp=e:GetLabelObject():GetControler()
	if Duel.SelectEffectYesNo(xp,e:GetLabelObject()) then
	local mg=Duel.GetDecktopGroup(xp,1)
	Duel.SendtoDeck(mg,1-xp,0,REASON_EFFECT)
	end
end










