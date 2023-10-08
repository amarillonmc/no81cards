local m=15000194
local cm=_G["c"..m]
cm.name="雪精灵"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	--aux.AddXyzProcedureLevelFree
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.xyzcon)
	e0:SetTarget(aux.XyzLevelFreeTarget(cm.mcfilter,cm.gfilter,3,3))
	--e0:SetOperation(cm.xyzop)
	e0:SetOperation(cm.XyzLevelFreeOperation(cm.mcfilter,cm.gfilter,3,3))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--
	c:EnableReviveLimit()
	--cannot be targeted
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.xcon)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--switch
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCost(cm.swcost)
	e2:SetTarget(cm.swtg)
	e2:SetOperation(cm.swop)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e2)
	--atk def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.con1)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(cm.con1)
	e5:SetValue(cm.atlimit)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(2)
	e6:SetCondition(cm.con2)
	e6:SetOperation(cm.drop)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.con3)
	e7:SetOperation(cm.disop)
	c:RegisterEffect(e7)
end
function cm.mcfilter(c,xyzc)
	return c:IsLevelAbove(1)
end
function cm.gfilter(g)
	return g:GetSum(Card.GetLevel)==9
end
function cm.xyzcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),15000194)==0 and aux.XyzLevelFreeCondition(cm.mcfilter,cm.gfilter,3,3)
end
function cm.xyzop(e)
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),15000194,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	aux.XyzLevelFreeOperation(cm.mcfilter,cm.gfilter,3,3)
end
function cm.XyzLevelFreeOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				Duel.RegisterFlagEffect(e:GetHandlerPlayer(),15000194,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
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
					Duel.Overlay(c,og)
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
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
function cm.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.swcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.swtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:GetFlagEffect(15000194)~=0 then
		c:ResetFlagEffect(15000194)
	end
end
function cm.swop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local select=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))+1
	c:RegisterFlagEffect(15000194,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,select,aux.Stringid(m,select))
end
function cm.con1(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(15000194)~=0 and c:GetFlagEffectLabel(15000194)==1
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE) and rc:IsControler(tp) and c:GetFlagEffect(15000194)~=0 and c:GetFlagEffectLabel(15000194)==2
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanDraw(tp,1) and c:GetFlagEffect(15000195)<=1 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,6)) then
		Duel.Hint(HINT_CARD,0,15000194)
		Duel.Draw(tp,1,REASON_EFFECT)
		c:RegisterFlagEffect(15000195,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15000194)~=0 and c:GetFlagEffectLabel(15000194)==3
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp==1-tp and Duel.IsChainDisablable(ev) and c:GetFlagEffect(15000196)==0 and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
		and (not rc:IsLocation(LOCATION_ONFIELD))
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,7)) then
		Duel.Hint(HINT_CARD,0,15000194)
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and not rc:IsLocation(LOCATION_DECK) then
			Duel.SendtoDeck(rc,nil,2,REASON_EFFECT)
		end
		c:RegisterFlagEffect(15000196,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end