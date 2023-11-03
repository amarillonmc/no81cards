local m=53796142
local cm=_G["c"..m]
cm.name="电子光虫-桌面蝽"
function cm.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2,cm.ovfilter,aux.Stringid(m,0),cm.xyzop)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.setcon)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.matcon)
	e2:SetTarget(cm.mattg)
	e2:SetOperation(cm.matop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		Screench_EffCodeAdjust=Effect.GetCode
		Effect.GetCode=function(te)
			local code=Screench_EffCodeAdjust(te)
			if code==EVENT_CUSTOM+m then return 1102 else return code end
		end
		Screench_Register=Card.RegisterEffect
		Card.RegisterEffect=function(tc,te,bool)
			if bool and Screench_EffCodeAdjust(te)==1102 and te:GetType()&EFFECT_TYPE_SINGLE then
				Duel.RegisterFlagEffect(0,m,0,0,0)
				local flag=Duel.GetFlagEffect(0,m)
				local tg=te:GetTarget()
				if not tg then tg=aux.TRUE end
				te:SetCode(EVENT_CUSTOM+m)
				te:SetTarget(cm.chtg(tg,flag))
				local ge1=Effect.CreateEffect(tc)
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(1102)
				ge1:SetOperation(cm.adjustop(flag))
				Duel.RegisterEffect(ge1,0)
			end
			return Screench_Register(tc,te,bool)
		end
	end
end
function cm.adjustop(flag)
	return function(e,tp,eg,ep,ev,re,r,rp)
			   if eg:IsContains(e:GetOwner()) then
				   Duel.RaiseSingleEvent(e:GetOwner(),EVENT_CUSTOM+m,re,r,rp,ep,flag)
				   e:Reset()
			   end
		   end
end
function cm.chtg(_tg,flag)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return ev==flag and _tg(e,tp,eg,ep,ev,re,r,rp,0) end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_INSECT) and c:GetLevel()>0
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsStatus(STATUS_JUST_POS)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+50)==0 end
	Duel.RegisterFlagEffect(tp,m+50,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetLabelObject():SetLabel(c:GetMaterial():GetFirst():GetLevel())
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.setfilter(c)
	return c:IsCode(10971759,47185546,86643777) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SSet(tp,tc)~=0 and c:IsRelateToEffect(e) then
		if c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RANK)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		c:CreateRelation(tc,RESET_EVENT+0x1fc0000)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(cm.costtg(c,tc))
		e2:SetOperation(cm.costop(c,tc))
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetLabelObject(e2)
		e3:SetOperation(cm.resetop(c,tc))
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.costtg(c,tc)
	return function(e,te,tp)
			   e:SetLabelObject(te)
			   return te:GetHandler()==tc and te:IsHasType(EFFECT_TYPE_ACTIVATE)
		   end
end
function cm.costop(c,tc)
	return function(e,tp,eg,ep,ev,re,r,rp)
			   local te=e:GetLabelObject()
			   if not c:IsRelateToCard(tc) or not c:IsCanChangePosition() then return end
			   local le={c:IsHasEffect(m)}
			   for _,v in pairs(le) do
				   if v:GetLabelObject() then v:GetLabelObject():Reset() end
				   v:Reset()
			   end
			   local g=c:GetOverlayGroup():Filter(function(c)return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_LIGHT)end,nil)
			   if #g>0 then
				   local cp={}
				   local pics={}
				   local func=Card.RegisterEffect
				   Card.RegisterEffect=function(tc,te,f)
					   if te:GetType()&(EFFECT_TYPE_FLIP+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 then table.insert(cp,te:Clone()) table.insert(pics,te:GetOwner():GetCode()) end
					   return func(tc,te,f)
				   end
				   for tc in aux.Next(g) do Duel.CreateToken(tp,tc:GetOriginalCode()) end
				   Card.RegisterEffect=func
				   for i,v in ipairs(cp) do
					   local pro1,pro2=v:GetProperty()
					   local des,cat,type,code,cost,con,tg,op=v:GetDescription(),v:GetCategory(),v:GetType(),v:GetCode(),v:GetCost(),v:GetCondition(),v:GetTarget(),v:GetOperation()
					   if not con then con=aux.TRUE end
					   if not cost then cost=aux.TRUE end
					   if not tg then tg=aux.TRUE end
					   local e1=Effect.CreateEffect(c)
					   e1:SetDescription(des)
					   e1:SetCategory(cat)
					   if type&EFFECT_TYPE_SINGLE~=0 then
						   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
						   e1:SetCode(code)
						   e1:SetCondition(con)
					   else
						   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
						   e1:SetCode(EVENT_CHAINING)
						   e1:SetCondition(cm.recon(te,con,code))
					   end
					   e1:SetRange(LOCATION_MZONE)
					   e1:SetProperty(pro1|EFFECT_FLAG_DELAY,pro2)
					   e1:SetCountLimit(1)
					   e1:SetCost(cost)
					   e1:SetTarget(cm.retg(tg,op,pics[i]))
					   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY+RESET_PHASE+PHASE_END)
					   c:RegisterEffect(e1,true)
					   local e2=Effect.CreateEffect(c)
					   e2:SetType(EFFECT_TYPE_SINGLE)
					   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					   e2:SetCode(m)
					   e2:SetLabelObject(e1)
					   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY+RESET_PHASE+PHASE_END)
					   c:RegisterEffect(e2,true)
				   end
			   end
			   if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)==0 then return end
		   end
end
function cm.recon(te,_con,code)
	return function(e,tp,eg,ep,ev,re,r,rp)
				if re~=te then return false end
				if not code or code==0 or code==EVENT_CHAINING then
					return _con(e,tp,eg,ep,ev,re,r,rp)
				else
					local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
					if not res then return false end
					return _con(e,tp,teg,tep,tev,tre,tr,trp)
				end
			end
end
function cm.retg(_tg,_op,pic)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return _tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return true end
				_tg(e,tp,eg,ep,ev,re,r,rp,1)
				Duel.Hint(HINT_CARD,0,pic)
				e:SetOperation(_op)
				local le={e:GetHandler():IsHasEffect(m)}
				for _,v in pairs(le) do
					local te=v:GetLabelObject()
					if te and te~=e then
						te:SetTarget(aux.FALSE)
						te:Reset()
					end
					v:Reset()
				end
			end
end
function cm.resetop(c,tc)
	return function(e,tp,eg,ep,ev,re,r,rp)
			   if c:IsLocation(LOCATION_OVERLAY) or tc:GetFlagEffect(m)==0 or not c:IsRelateToCard(tc) then
				   e:GetLabelObject():Reset()
				   e:Reset()
			   end
		   end
end
function cm.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.xyzfilter(c,e,res)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (res or not c:IsImmuneToEffect(e))
end
function cm.matfilter(c)
	return c:IsLevel(3) and c:IsCanOverlay()
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,true) and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.matfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	if #g==0 then return end
	Duel.Overlay(tc,g)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.efop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	cm[e1]={}
end
function cm.gfilter(c,g)
	if not g or #g==0 then return true end
	return not g:IsContains(c)
end
function cm.gfilter1(c,g)
	if not g or #g==0 then return true end
	return not g:IsExists(cm.gfilter2,1,nil,c:GetOriginalCode())
end
function cm.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=cm[e]
	local exg=Group.CreateGroup()
	for tc,tab in pairs(copyt) do
		if tc and tab then exg:AddCard(tc) end
	end
	local g=c:GetOverlayGroup():Filter(function(c)return c:IsRace(RACE_INSECT) and c:IsLevel(3)end,nil)
	local dg=exg:Filter(cm.gfilter,nil,g)
	for tc in aux.Next(dg) do
		if not c:IsLocation(LOCATION_OVERLAY) and not tc:IsLocation(LOCATION_OVERLAY) and not c:IsPreviousLocation(LOCATION_OVERLAY) then
			for _,v in pairs(copyt[tc]) do v:Reset() end
			exg:RemoveCard(tc)
			copyt[tc]=nil
		end
	end
	local cg=g:Filter(cm.gfilter,nil,exg)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local pro1,pro2=te:GetProperty()
		if te:GetType()&(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FLIP+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)==0 and pro1&EFFECT_FLAG_UNCOPYABLE==0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(cg) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		local gcp={}
		for _,v in pairs(cp) do
			local pro1,pro2=v:GetProperty()
			local e1=Effect.CreateEffect(c)
			e1:SetType(v:GetType())
			e1:SetCode(v:GetCode())
			e1:SetProperty(pro1,pro2)
			if v:GetRange() and v:GetRange()~=0 then e1:SetRange(v:GetRange()) end
			if v:GetCondition() then e1:SetCondition(v:GetCondition()) end
			if v:GetCost() then e1:SetCost(v:GetCost()) end
			if v:GetTarget() then e1:SetTarget(v:GetTarget()) end
			if v:GetOperation() then e1:SetOperation(v:GetOperation()) end
			e1:SetReset(RESET_EVENT+0x17e0000)
			f(c,e1,true)
			table.insert(gcp,e1)
		end
		cp={}
		copyt[tc]=gcp
	end
	Card.RegisterEffect=f
	cm[e]=copyt
end
