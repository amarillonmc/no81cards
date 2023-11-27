if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EVENT_CUSTOM+id)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	s.self_destroy_effect=e4
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(id)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.reset)
		Duel.RegisterEffect(ge2,0)
		s.trigger={}
		local f=function(c)return(c:IsLocation(LOCATION_DECK) or c:IsFacedown()) and not c:IsLocation(LOCATION_HAND)end
		local _SelectUnselect=Group.SelectUnselect
		function Group.SelectUnselect(cg,sg,sp,finish,cancel,...)
			if Duel.IsPlayerAffectedByEffect(sp,id) and s.chain_solving then 
				local g=_SelectUnselect(cg,sg,sp,finish,false,...)
				local tg=Group.__add(g,g)
				if tg:IsExists(f,1,nil) then table.insert(s.trigger,sp) end
				return g
			else return _SelectUnselect(cg,sg,sp,finish,cancel,...) end
		end
		local originalDuelFunctions={}
		local DuelFunctionsName={"SelectMatchingCard","SelectReleaseGroup","SelectReleaseGroupEx","SelectTarget","SelectTribute","SelectFusionMaterial","SelectSynchroMaterial","SelectTunerMaterial","SelectXyzMaterial"}
		for _,funcName in ipairs(DuelFunctionsName) do
			originalDuelFunctions[funcName]=Duel[funcName]
			Duel[funcName]=function(sp,...)
				if Duel.IsPlayerAffectedByEffect(sp,id) and s.chain_solving then 
					local g=originalDuelFunctions[funcName](sp,...)
					local tg=Group.__add(g,g)
					if tg:IsExists(f,1,nil) then table.insert(s.trigger,sp) end
					return g
				else return originalDuelFunctions[funcName](sp,...) end
			end
		end
		local originalGroupFunctions={}
		local GroupFunctionsName={"FilterSelect","Select","RandomSelect","SelectWithSumEqual","SelectWithSumGreater",""}
		for _,funcName in ipairs(GroupFunctionsName) do
			originalGroupFunctions[funcName]=Group[funcName]
			Group[funcName]=function(group,sp,...)
				if Duel.IsPlayerAffectedByEffect(sp,id) and s.chain_solving then 
					local g=originalGroupFunctions[funcName](group,sp,...)
					local tg=Group.__add(g,g)
					if tg:IsExists(f,1,nil) then table.insert(s.trigger,sp) end
					return g
				else return originalGroupFunctions[funcName](group,sp,...) end
			end
		end
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=true
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=false
	local t=s.trigger
	s.trigger={}
	local p=3
	if SNNM.IsInTable(0,t) and SNNM.IsInTable(1,t) then p=2 elseif SNNM.IsInTable(0,t) then p=0 elseif SNNM.IsInTable(1,t) then p=1 end
	if p>2 then return end
	Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id,re,r,rp,p,ev)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
	if Duel.GetFlagEffect(tp,id)>0 then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetBattleMonster(tp)
	if not (ac and ac:IsFaceup() and ac:IsSetCard(0x5534)) then return false end
	local bc=ac:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ac,bc=Duel.GetBattleMonster(tp)
	if chk==0 then return ac:IsAbleToHand() and bc:IsAbleToHand() end
	local g=Group.FromCards(ac,bc)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	--[[local tk=Duel.CreateToken(1,55144522)
	Duel.SendtoGrave(tk,REASON_EFFECT)
	tk=Duel.CreateToken(1,403847)
	Duel.SendtoGrave(tk,REASON_EFFECT)--]]
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetActivateEffect()end,0,0xff,0xff,nil)
	local ct=0
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			--if tc:IsCode(53766016) then Debug.Message(i) end
			if v:GetRange()&0x2~=0 then
			local ctype=tc:GetType()
			local e1=v:Clone()
			local cd=v:GetCode()
			local pr1,pr2=v:GetProperty()
			if cd==EVENT_FREE_CHAIN or cd==EVENT_SUMMON or cd==EVENT_FLIP_SUMMON or cd==EVENT_SPSUMMON or cd==EVENT_CHAINING then
				if ctype&(TYPE_TRAP+TYPE_QUICKPLAY)~=0 then e1:SetType(EFFECT_TYPE_QUICK_O) else e1:SetType(EFFECT_TYPE_IGNITION) e1:SetCode(0) end
				e1:SetProperty(pr1|EFFECT_FLAG_BOTH_SIDE,pr2)
			else
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				e1:SetCode(0x160000000+id+cd+ct*100000)
				e1:SetCondition(aux.TRUE)
				local con=v:GetCondition()
				local tg=v:GetTarget()
				if not con then con=aux.TRUE end
				if not tg then tg=aux.TRUE end
				e1:SetTarget(s.chtg(tg))
				local ge1=Effect.CreateEffect(tc)
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(cd)
				ge1:SetOperation(s.check(ct,con,tg))
				Duel.RegisterEffect(ge1,0)
				e1:SetProperty(pr1|EFFECT_FLAG_EVENT_PLAYER,pr2)
				ct=ct+1
			end
			e1:SetRange(LOCATION_GRAVE)
			tc:RegisterEffect(e1,true)
			--[[local e1_1=Effect.CreateEffect(tc)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1_1:SetCode(53765098)
			e1_1:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD)
			e1_1:SetLabel(ctype)
			e1_1:SetLabelObject(e1)
			tc:RegisterEffect(e1_1,true)-]]
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetRange(LOCATION_GRAVE)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetLabelObject(e1)
			e2:SetOperation(SNNM.AASTadjustop(ctype))
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_ACTIVATE_COST)
			e3:SetRange(LOCATION_GRAVE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetTargetRange(1,1)
			e3:SetLabelObject(e1)
			e3:SetTarget(SNNM.AASTactarget)
			e3:SetCost(s.costchk(ctype))
			e3:SetOperation(SNNM.AdvancedActOp(ctype,s.costop))
			tc:RegisterEffect(e3,true)
			end
		end
	end
	e:Reset()
end
function s.chtg(tg)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return true end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function s.check(i,con,tg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if con(e,0,eg,ep,ev,re,r,rp) and tg(e,0,eg,ep,ev,re,r,rp,0) then Duel.RaiseEvent(eg,0x160000000+id+e:GetCode()+i*100000,re,r,rp,0,0) end
				if con(e,1,eg,ep,ev,re,r,rp) and tg(e,1,eg,ep,ev,re,r,rp,0) then Duel.RaiseEvent(eg,0x160000000+id+e:GetCode()+i*100000,re,r,rp,1,0) end
			end
end
function s.costchk(ctype)
	return  function(e,te_or_c,tp)
				local p=1-e:GetHandler():GetControler()
				return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or ctype&TYPE_FIELD~=0) and tp==p and Duel.GetFlagEffect(p,id)>Duel.GetFlagEffect(p,id+33)
			end
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.RegisterFlagEffect(tp,id+33,RESET_PHASE+PHASE_END,0,1)
end
--[[function s.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end--]]
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp or ep==2
end
function s.filter(c)
	return c:IsSetCard(0x5534) and c:IsAbleToDeck()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_DECK) then Duel.Draw(tp,2,REASON_EFFECT) end
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end
