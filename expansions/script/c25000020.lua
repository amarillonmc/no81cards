--飞电龙-程式升煌
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,3,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.sdcost)
	e1:SetTarget(s.sdtg)
	e1:SetOperation(s.sdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end
function s.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.sdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return false end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	ct=e:GetHandler():RemoveOverlayCard(tp,1,ct,REASON_COST)
	e:SetLabel(ct)
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetLabel()
	local ct=math.min(at,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if ct>0 then
		local t={}
		for i=1,ct do
			t[i]=i
		end
		local ac=1
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		Duel.SortDecktop(tp,tp,ac)
	end
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
end
function s.ovfilter(c)
	return c:IsCanOverlay()
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cl=Duel.GetCurrentChain()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()>0 then
		local xc=g:GetFirst()
		Duel.Overlay(c,g)
		Debug.Message(cl)
		Debug.Message(ac)
		if cl>=2 and xc:IsCode(ac) and Duel.IsExistingMatchingCard(s.ovfilter,tp,0,LOCATION_ONFIELD,1,nil,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local sg=Duel.GetMatchingGroup(s.ovfilter,tp,0,LOCATION_ONFIELD,c)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			local tc=tg:GetFirst()
			if not tc:IsImmuneToEffect(e) then
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(c,tg)
			end
		end
	end
end