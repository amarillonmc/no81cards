local m=15006126
local cm=_G["c"..m]
cm.name="风的余音"
function cm.initial_effect(c)
	local e1=aux.AddRitualProcGreaterCode(c,15006125,LOCATION_HAND+LOCATION_GRAVE,nil,nil,true,cm.extraop)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function cm.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	if not mat then return end
	local atk=mat:GetSum(Card.GetBaseAttack)
	if atk>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		local val=Duel.Damage(tp,atk,REASON_EFFECT)
		local ct=math.floor(val/1000)
		if ct>3 then ct=3 end
		local off=1
		local ops={}
		local opval={}
		--battle ind
		ops[off]=aux.Stringid(m,2)
		opval[off]=1
		off=off+1
		--effect ind
		ops[off]=aux.Stringid(m,3)
		opval[off]=2
		off=off+1
		--target ind
		ops[off]=aux.Stringid(m,4)
		opval[off]=4
		off=off+1
		local ops_lp_equal={table.unpack(ops)}
		local opval_lp_equal={table.unpack(opval)}
		local op=0
		local cct=0
		while cct<ct do
			local sel
			local selval
			sel=Duel.SelectOption(tp,table.unpack(ops))+1
			selval=opval[sel]
			if selval==0 then break end
			table.remove(ops,sel)
			table.remove(opval,sel)
			table.remove(ops_lp_equal,sel)
			table.remove(opval_lp_equal,sel)
			op=op|selval
			cct=cct+1
		end
		if op&1~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		if op&2~=0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetDescription(aux.Stringid(m,3))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
		end
		if op&4~=0 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetDescription(aux.Stringid(m,4))
			e3:SetRange(LOCATION_MZONE)
			e3:SetLabel(tp)
			e3:SetValue(cm.tgval)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end
	end
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetLabel()
end