--拓扑终端世界蛇
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,4,s.lcheck)
	--zone limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MUST_USE_MZONE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(s.zonelimit)
	c:RegisterEffect(e0)
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.efilter)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(s.rmlimit)
	c:RegisterEffect(e5)
end
function s.zonelimit(e)
	return 0x1f001f | (0x600060 & ~e:GetHandler():GetLinkedZone())
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x16e)
end
function s.matfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x16e)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.matfilter,1,nil) then
		local ct=g:GetSum(Card.GetLink)
		e:GetLabelObject():SetLabel(1,ct-1)
	else
		e:GetLabelObject():SetLabel(0,0)
	end
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ls,ct=e:GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and ls==1
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	local zone=bit.band(c:GetLinkedZone(1-tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local zone=bit.band(c:GetLinkedZone(1-tp),0x1f)
		if tc:IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 then
			local s=0
			local flag=bit.bxor(zone,0xff)*0x10000
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
			local nseq=0
			if s==1 then nseq=0
			elseif s==2 then nseq=1
			elseif s==4 then nseq=2
			elseif s==8 then nseq=3
			else nseq=4 end
			Duel.MoveSequence(tc,nseq)
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.RaiseEvent(Group.FromCards(tc),EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end
function s.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:IsPreviousControler(1) then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.cfilter,1,nil,zone)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.efilter(e,c)
	return c:IsSetCard(0x16e)
end
function s.rmlimit(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x16e) and c:IsFaceup()
		and r&REASON_EFFECT~=0 and r&REASON_REDIRECT==0
end