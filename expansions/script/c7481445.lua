--守墓的奉神者
local s,id,o=GetID()
function s.initial_effect(c)
	 --fusion material
	--local fun={}
	--for i=1,63 do
	--  fun[i]=aux.TRUE 
	--end
	--Debug.Message(#fun)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,false,true,aux.TRUE,1,63,s.fusfilter1,s.fusfilter1)
	--aux.AddFusionProcMix(c,false,true,s.fusfilter1,s.fusfilter1,table.unpack(fun))
	--grave fusion material
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,6))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
	if not s.globle_check then
		--chain check
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.chainop)
		Duel.RegisterEffect(ge1,0)

		s.globle_check=true
		Gravekeeper_hack_fusion_check=Card.CheckFusionMaterial
		Gravekeeper_hack_fusion_group=Group.CreateGroup
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			Gravekeeper_hack_fusion_group=Group.CreateGroup()
			if card:GetOriginalCode()==id then
				exg=Duel.GetMatchingGroup(s.filter0,int_chkf,LOCATION_GRAVE,LOCATION_GRAVE,nil,card)
				exg=Group.__bxor(exg,Group_fus):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				if exg:GetCount()>0 then
					if Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+o)==0 then
						Duel.RegisterFlagEffect(0,id+o,RESET_EVENT+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(card)
						e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e1:SetCode(EVENT_CHAIN_SOLVED)
						e1:SetOperation(s.resetop)
						e1:SetReset(RESET_EVENT+RESET_CHAIN)
						Duel.RegisterEffect(e1,0)
						local e2=e1:Clone()
						e2:SetCode(EVENT_CHAIN_NEGATED)
						Duel.RegisterEffect(e2,0)
					end
					local hg=Group.__add(exg,Group_fus)
					return Gravekeeper_hack_fusion_check(card,hg,Card_g,int_chkf,not_mat)
				end
			end
			return Gravekeeper_hack_fusion_check(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		Gravekeeper_hack_fusion_select=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(tp,card,mg,gc_nil,chkf)
			if card:GetOriginalCode()==id and Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+o)~=0 then
				local exg=Duel.GetMatchingGroup(s.filter0,int_chkf,LOCATION_GRAVE,LOCATION_GRAVE,nil,card)
				if exg:GetCount()>0 then
					mg:Merge(exg)
					Gravekeeper_hack_fusion_group=exg
				end
			end
			Duel.ResetFlagEffect(0,id+o)
			return Gravekeeper_hack_fusion_select(tp,card,mg,gc_nil,chkf)
		end
		Gravekeeper_hack_fusion_SendtoGrave=Duel.SendtoGrave
		function Duel.SendtoGrave(tg,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or aux.GetValueType(tg)~="Group" then
				return Gravekeeper_hack_fusion_SendtoGrave(tg,reason)
			end
			local rg=tg:Filter(s.fusion_filter,nil)
			tg:Sub(rg)
			local ct1=Gravekeeper_hack_fusion_SendtoGrave(tg,reason)
			local ct2=Duel.SendtoDeck(rg,nil,2,reason)
			return ct1+ct2
		end
		Gravekeeper_hack_fusion_Remove=Duel.Remove
		function Duel.Remove(tg,pos,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or aux.GetValueType(tg)~="Group" then
				return Gravekeeper_hack_fusion_Remove(tg,pos,reason)
			end
			local rg=tg:Filter(s.fusion_filter,nil)
			tg:Sub(rg)
			local ct1=Gravekeeper_hack_fusion_Remove(tg,pos,reason)
			local ct2=Duel.SendtoDeck(rg,nil,2,reason)
			return ct1+ct2
		end
		Gravekeeper_hack_fusion_SendtoHand=Duel.SendtoHand
		function Duel.SendtoHand(tg,p,reason)
			if reason~=REASON_EFFECT+REASON_MATERIAL+REASON_FUSION or aux.GetValueType(tg)~="Group" then
				return Gravekeeper_hack_fusion_SendtoHand(tg,p,reason)
			end
			local rg=tg:Filter(s.fusion_filter,nil)
			tg:Sub(rg)
			local ct1=Gravekeeper_hack_fusion_SendtoHand(tg,p,reason)
			local ct2=Duel.SendtoDeck(rg,nil,2,reason)
			return ct1+ct2
		end
	end
end
function s.fusfilter1(c)
	return c:IsSetCard(0x2e)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,id,RESET_EVENT+RESET_CHAIN,0,1)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,id)
	e:Reset()
end
function s.filter0(c,fc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
end
function s.fusion_filter(c)
	return c:IsLocation(LOCATION_GRAVE) and Gravekeeper_hack_fusion_group and 
		   Gravekeeper_hack_fusion_group:IsContains(c)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	local tc=g:GetFirst()
	while tc do
		if tc:GetLevel()>0 then
			ct=ct+tc:GetLevel()
		end
		if tc:GetRank()>0 then
			ct=ct+tc:GetRank()
		end
		if tc:GetLink()>0 then
			ct=ct+tc:GetLink()
		end
		tc=g:GetNext()
	end
	e:SetLabel(ct)
	e:GetLabelObject():SetLabel(#g)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.filter(c)
	return c:IsFacedown()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local b1=e:GetLabelObject():GetLabel()>0
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return ct>0 and (b1 or b2 or b3) end
	local sel={}
	local off=0
	local des=false
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(id,2)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(id,3)
			opval[off-1]=2
			off=off+1
			des=true
		end
		if b3 then
			ops[off]=aux.Stringid(id,4)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		sel[#sel+1]=opval[op]
		ct=ct-1
	until ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,5))
	e:SetLabel(table.unpack(sel))
	if des then
		local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel={e:GetLabel()}
	local ct=1
	while sel[ct] do
		Duel.Hint(HINT_CARD,0,id+sel[ct])
		if sel[ct]==1 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local lv=e:GetLabelObject():GetLabel()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(lv*100)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		if sel[ct]==2 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if sel[ct]==3 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.BreakEffect()
				while tc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(-1000)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					tc:RegisterEffect(e2)
					tc=g:GetNext()
				end
			end
		end
		ct=ct+1
	end
end
