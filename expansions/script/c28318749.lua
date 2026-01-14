--辉光的一等星 光芒的终点
function c28318749.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(Auxiliary.XyzLevelFreeCondition(c28318749.mfilter,c28318749.xyzcheck,2,99))
	e0:SetTarget(Auxiliary.XyzLevelFreeTarget(c28318749.mfilter,c28318749.xyzcheck,2,99))
	e0:SetOperation(c28318749.Operation(c28318749.mfilter,c28318749.xyzcheck,2,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetCost(c28318749.tdcost)
	e1:SetTarget(c28318749.tdtg)
	e1:SetOperation(c28318749.tdop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c28318749.reptg)
	e2:SetValue(c28318749.repval)
	e2:SetOperation(c28318749.repop)
	c:RegisterEffect(e2)
	if not ILLUMINA_EFFECT_HINT then
		ILLUMINA_EFFECT_HINT = true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c28318749.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--xyz↓
function c28318749.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsRace(RACE_FAIRY)
end
function c28318749.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c28318749.Operation(f,gf,minct,maxct)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local ct=0
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					if og:GetClassCount(Card.GetRank)==1 then ct=og:GetFirst():GetRank() end
					Duel.Overlay(c,og)
					if ct~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28318749.rscon)
						e1:SetOperation(c28318749.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					if mg:GetClassCount(Card.GetRank)==1 then ct=mg:GetFirst():GetRank() end
					Duel.Overlay(c,mg)
					if ct~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_SPSUMMON_SUCCESS)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e1:SetCondition(c28318749.rscon)
						e1:SetOperation(c28318749.rsop)
						e1:SetLabelObject(c)
						e1:SetLabel(ct)
						Duel.RegisterEffect(e1,tp)
					end
					mg:DeleteGroup()
				end
			end
end
function c28318749.rscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function c28318749.rsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	tc:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c28318749.atkval)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e4)
	e:Reset()
end
--xyz↑
function c28318749.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c28318749.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsExistingTarget(c28318749.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c28318749.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	tg:Merge(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,2,0,0)
end
function c28318749.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c28318749.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsRace(RACE_FAIRY) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c28318749.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c28318749.repfilter,1,nil,tp)
		and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c28318749.repval(e,c)
	return c28318749.repfilter(c,e:GetHandlerPlayer())
end
function c28318749.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,28318749)
end
function c28318749.atkval(e,c)
	return c:GetRank()*100
end
function c28318749.checkop(e,tp,eg,ep,ev,re,r,rp)
	local member_list={28315443,28315548,28315746}
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsCode,p,0xff,0,nil,table.unpack(member_list))
		if g:GetClassCount(Card.GetCode)==#member_list then
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_CUSTOM+28318749)
			ge1:SetOperation(c28318749.hintop)
			Duel.RegisterEffect(ge1,p)
		end
	end
	e:Reset()
end
function c28318749.hintop(e,tp,eg,ep,ev,re,r,rp)
	--if rp~=tp then return end
	local member_list={28315443,28315548,28315746}--ascending order
	for _,te in pairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+28318749)}) do te:Reset() end
	for i,code in pairs(member_list) do
		local ct=Duel.GetFlagEffectLabel(tp,code) or 0
		local te=Effect.CreateEffect(e:GetHandler())
		te:SetDescription(aux.Stringid(member_list[i],ct+5))
		te:SetType(EFFECT_TYPE_FIELD)
		te:SetCode(EFFECT_FLAG_EFFECT+28318749)
		te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		te:SetTargetRange(1,0)
		te:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(te,tp)
	end
end
